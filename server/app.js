var express = require('express');
var app = express();
var path = require('path');
var bodyParser = require('body-parser');

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// statis: js,img,css
app.use('/bootstrap', express.static(__dirname + '/node_modules/bootstrap/dist/'));
app.use(express.static(path.join(__dirname, './public')));

// routes
var routes = require('./routes/index');
app.use('/', routes);

module.exports = app;
