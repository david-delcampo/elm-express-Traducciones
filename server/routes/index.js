var fs = require('fs');
var express = require('express');
var router = express.Router();

const PATH_DATAFILE = './db/data.json';

//http://stackoverflow.com/questions/10011011/using-node-js-how-do-i-read-a-json-object-into-server-memory
router.get('/', function(req, res) {
  var obj = JSON.parse(fs.readFileSync(PATH_DATAFILE, 'utf8'));  

  res.json(obj);
});

//https://nodejs.org/api/fs.html
//http://stackoverflow.com/questions/10005939/how-to-consume-json-post-data-in-an-express-application
router.post('/', function(req, res) {  
  fs.writeFileSync(PATH_DATAFILE, JSON.stringify(req.body));
  
  res.send(req.body);
});

module.exports = router;
