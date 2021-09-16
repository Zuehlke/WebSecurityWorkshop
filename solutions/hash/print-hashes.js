const fs = require('fs');

let rawdata = fs.readFileSync('response.json');
let res = JSON.parse(rawdata);

res.data.forEach(element => {
    console.log(element.name + ":" + element.description);
});