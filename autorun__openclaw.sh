#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/ultimate_ai"
MODEL_DIR="$INSTALL_DIR/models"
SERVICE_NAME="ultimate_ai"

echo "========================================"
echo " ULTIMATE LOCAL AI SERVER (4GB RAM)"
echo " DeepSeek + llama.cpp server"
echo "========================================"

echo "[1/8] Installing dependencies..."

sudo apt update
sudo apt install -y \
git \
build-essential \
cmake \
python3 \
python3-pip \
curl \
wget

echo "[2/8] Creating directories..."

mkdir -p $INSTALL_DIR
mkdir -p $MODEL_DIR

cd $INSTALL_DIR

echo "[3/8] Installing llama.cpp..."

git clone https://github.com/ggerganov/llama.cpp

cd llama.cpp
make -j4

cd ..

echo "[4/8] Downloading AI model..."

cd $MODEL_DIR

wget -O model.gguf \
https://huggingface.co/TheBloke/deepseek-coder-1.3b-instruct-GGUF/resolve/main/deepseek-coder-1.3b-instruct.Q4_K_M.gguf

cd ..

echo "[5/8] Installing backend..."

pip3 install flask flask-cors requests

echo "[6/8] Creating API bridge..."

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
        "temperature":0.7
    })

    data=r.json()

    text=data["content"]

    history.append({"role":"assistant","content":text})

    if len(history)>8:
        history=history[-8:]

    return jsonify({"response":text})

app.run(host="0.0.0.0",port=8000)
EOF

echo "[7/8] Creating Chat UI..."

mkdir -p $INSTALL_DIR/web

cat << 'EOF' > $INSTALL_DIR/web/index.html
<!DOCTYPE html>
<html>

<head>

<title>Ultimate Local AI</title>

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

</style>

</head>

<body>

<h2 align="center">Ultimate Local AI</h2>

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

echo "[8/8] Creating run script..."

cat << 'EOF' > $INSTALL_DIR/run.sh
#!/usr/bin/env bash

cd ~/ultimate_ai

./llama.cpp/server -m models/model.gguf -c 2048 -t 2 --host 0.0.0.0 --port 8080 &

python3 api.py &

python3 -m http.server 3000 --directory web
EOF

chmod +x $INSTALL_DIR/run.sh

sudo bash -c "cat > /etc/systemd/system/$SERVICE_NAME.service" <<EOF
[Unit]
Description=Ultimate Local AI
After=network.target

[Service]
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/run.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo ""
echo "========================================"
echo " AI SERVER READY"
echo "========================================"

echo ""
echo "Open browser:"
echo ""
echo "http://localhost:3000"

echo ""
echo "Check logs:"
echo ""
echo "journalctl -u $SERVICE_NAME -f"
