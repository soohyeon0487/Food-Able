var async = require('async');
var mysql = require('mysql');

module.exports = function(app, pool) {
  
  app.get('/',function(req,res){
    console.log('hello')
    res.send('Hello World');
  });

  // 대학 목록 조회
  app.get('/universities',function(req,res){
    
    var query = 'SELECT * FROM UNIVERSITIES';
    console.log('/universities - SQL : ' + query);

    pool.getConnection(function(error, connection) {
      connection.query(query, function(error, rows) {
        if (error) {
          connection.release();
          console.error('/universities - Error : ' + error);
          res.send(error);
        } else {
          connection.release();
          console.log('/universities - Success');
          res.send(rows);
        }
      })
    })
  });

  // 대학 목록 버전 조회
  app.get('/universities/version',function(req,res){
    
    var query = 'SELECT VERSION FROM VERSIONS WHERE item = "universities"';
    console.log('/universities/version - SQL : ' + query);

    pool.getConnection(function(error, connection) {
      connection.query(query, function(error, rows) {
        if (error) {
          connection.release();
          console.error('/universities/version - Error : ' + error);
          res.send(error);
        } else {
          connection.release();
          console.log('/universities/version - Success');
          res.send(rows);
        }
      })
    })
  });

  // 가게 목록 조회
  app.get('/stores',function(req,res){
    
    var query = 'SELECT * FROM STORES';
    console.log('/stores - SQL : ' + query);

    pool.getConnection(function(error, connection) {
      connection.query(query, function(error, rows) {
        if (error) {
          connection.release();
          console.error('/stores - Error : ' + error);
          res.send(error);
        } else {
          connection.release();
          console.log('/stores - Success');
          res.send(rows);
        }
      })
    })
  });

  // 대학 목록 버전 조회
  app.get('/stores/version',function(req,res){
    
    var query = 'SELECT VERSION FROM VERSIONS WHERE item = "stores"';
    console.log('/stores/version - SQL : ' + query);

    pool.getConnection(function(error, connection) {
      connection.query(query, function(error, rows) {
        if (error) {
          connection.release();
          console.error('/stores/version - Error : ' + error);
          res.send(error);
        } else {
          connection.release();
          console.log('/stores/version - Success');
          res.send(rows);
        }
      })
    })
  });

  // 음식 목록 조회
  app.get('/food',function(req,res){
    var query = 'SELECT * FROM FOOD';
    console.log(query);
    res.send('');
  });
}
