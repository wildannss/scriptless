const delay = require('delay');
const fs = require('fs');

// Server
const serv = 'Herza';
const wait = 2 // in minute
// Client
const chat = 285810888;

// Start Script
(async () => {
    try{
        let i = 1;
        while(true){
            try{
                await fetch(`https://api.telegram.org/bot5851565456:AAHqmuey2tCxE43cqPaHuLILBEXCjD5CXiU/sendMessage?text=${serv}&chat_id=${chat}`);
                console.log(`Sending ${i}x Message Telegram`);
                await delay(wait * 60000);
                i++;
            }catch{
                console.log('Trying Again ...')
            };
        };
    }catch(err){
        let e = 1;
        if(err['errorMessage'] === 'FLOOD'){
            await fetch(`https://api.telegram.org/bot2013105572:AAH1WNGcIbUfw8EUQq3UPJT7NMi3XK8wE-s/sendMessage?text=Server%20${serv}%20Tele%20Flood%20Begin%20...&chat_id=277081400`);
            for(let x = 0; x <= parseInt(err['seconds']); x++){
                await delay(1000);
                console.log(`Waiting Flood ${e} of ${err['seconds']}`);
                e++;
            };
            await fetch(`https://api.telegram.org/bot2013105572:AAH1WNGcIbUfw8EUQq3UPJT7NMi3XK8wE-s/sendMessage?text=Server%20${serv}%20Tele%20Flood%20End%20...&chat_id=277081400`);
            await fetch(`https://api.telegram.org/bot5851565456:AAHqmuey2tCxE43cqPaHuLILBEXCjD5CXiU/sendMessage?text=${serv}&chat_id=${chat}`);
        }else{
            await fetch(`https://api.telegram.org/bot2013105572:AAH1WNGcIbUfw8EUQq3UPJT7NMi3XK8wE-s/sendMessage?text=Server%20${serv}%20Error%20check%20it%20Out%20...&chat_id=277081400`);
            console.log(`Sent Error Notif Server ...`);
            await delay(wait * 60000);
        };
    };
})();