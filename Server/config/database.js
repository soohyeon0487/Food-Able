const mysql = require('mysql');

const dbInfo = {
  host     : '192.168.0.105',
  port     : '3306',
  user     : 'foodable_user',
  password : 'foodable0000',
  database : 'foodable',
  connectionLimit: 20,
  waitForConnections: false
};

module.exports = {
  init: function () {
    return mysql.createPool(dbInfo);
  }
};