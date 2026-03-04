#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/openclaw_ai"
MODEL_DIR="$INSTALL_DIR/models"
SERVICE_NAME="openclaw_ai"

echo "======================================"
echo " OPENCLAW ULTIMATE INSTALLER"
echo " Ubuntu 24 Desktop"
echo "======================================"

echo "[1/12] Update system..."

sudo apt update
sudo apt upgrade -y

echo "[2/12] Install dependencies..."

sudo apt install -y \
git \
curl \
wget \
build-essential \
cmake \
python3 \
python3-pip \
python3-venv \
libopenblas-dev

echo "[3/12] Create swap (4GB)..."

sudo swapoff -a || true
sudo rm -f /swapfile || true

sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "[4/12] Create directories..."

mkdir -p $INSTALL_DIR
mkdir -p $MODEL_DIR

cd $INSTALL_DIR

echo "[5/12] Clone OpenClaw..."

git clone https://github.com/openclaw/openclaw.git || true

echo "[6/12] Install llama.cpp..."

git clone https://github.com/ggerganov/llama.cpp

cd llama.cpp
make -j$(nproc)

cd ..

echo "[7/12] Download AI model..."

cd $MODEL_DIR

wget -O deepseek.gguf \
https://huggingface.co/TheBloke/deepseek-coder-1.3b-instruct-GGUF/resolve/main/deepseek-coder-1.3b-instruct.Q4_K_M.gguf

cd ..

echo "[8/12] Setup Python environment..."

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip

pip install flask flask-cors requests markdown pygments

echo "[9/12] Create AI API..."

cat << 'EOF' > $INSTALL_DIR/api.py
import requests
from flask import Flask,request,jsonify

LLAMA_SERVER="http://localhost:8080/completion"

app=Flask(__name__)

history=[]

@app.route("/chat",methods=["POST"])
def chat():

    global history

    msg=request.json["message"]

    history.append({"role":"user","content":msg})

    prompt=""

    for m in history:
        prompt+=m["role"]+": "+m["content"]+"\n"

    prompt+="assistant:"

    r=requests.post(LLAMA_SERVER,json={
        "prompt":prompt,
        "n_predict":200,
        "temperature":0.7,
        "stream":False
    })

    data=r.json()

    text=data["content"]

    history.append({"role":"assistant","content":text})

    if len(history)>12:
        history=history[-12:]

    return jsonify({"response":text})

app.run(host="0.0.0.0",port=8000)
EOF

echo "[10/12] Create ChatGPT-style UI..."

mkdir -p $INSTALL_DIR/web

cat << 'EOF' > $INSTALL_DIR/web/index.html
<!DOCTYPE html>
<html>

<head>

<title>OpenClaw AI</title>

<style>

body{
background:#0d1117;
color:white;
font-family:Arial;
}

#chat{
width:80%;
margin:auto;
margin-top:30px;
}

.msg{
padding:12px;
margin:10px;
border-radius:10px;
}

.user{
background:#2f81f7;
}

.ai{
background:#30363d;
}

input{
width:70%;
padding:10px;
}

button{
padding:10px;
}

pre{
background:#111;
padding:10px;
overflow:auto;
}

</style>

</head>

<body>

<h2 align="center">OpenClaw AI</h2>

<div id="chat"></div>

<center>

<input id="input" placeholder="Ask something...">

<button onclick="send()">Send</button>

</center>

<script>

async function send(){

let input=document.getElementById("input")

let msg=input.value

add(msg,"user")

input.value=""

let res=await fetch("http://localhost:8000/chat",{

method:"POST",

headers:{"Content-Type":"application/json"},

body:JSON.stringify({message:msg})

})

let data=await res.json()

add(data.response,"ai")

}

function add(text,type){

let div=document.createElement("div")

div.className="msg "+type

div.innerText=text

document.getElementById("chat").appendChild(div)

}

</script>

</body>

</html>
EOF

echo "[11/12] Create run script..."

cat << 'EOF' > $INSTALL_DIR/run.sh
#!/usr/bin/env bash

cd ~/openclaw_ai

./llama.cpp/server -m models/deepseek.gguf -c 2048 -t 2 --port 8080 &

source venv/bin/activate
python api.py &

python3 -m http.server 3000 --directory web
EOF

chmod +x $INSTALL_DIR/run.sh

echo "[12/12] Create systemd service..."

sudo bash -c "cat > /etc/systemd/system/$SERVICE_NAME.service" <<EOF
[Unit]
Description=OpenClaw AI Server
After=network.target

[Service]
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/run.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo ""
echo "======================================"
echo " OPENCLAW AI READY"
echo "======================================"

echo ""
echo "Open browser:"
echo "http://localhost:3000"

echo ""
echo "Check logs:"
echo "journalctl -u $SERVICE_NAME -f"
