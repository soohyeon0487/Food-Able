var express = require('express');
var mysql = require('mysql');
var bodyParser = require('body-parser')
var dbConfig = require('./config/database.js');

var app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
var pool = dbConfig.init();

app.listen(3000, () => {
  console.log("Express server has started on port 3000")
});

var routes = require('./router')(app, pool);

/////////////////////////////////////////////////////////////

