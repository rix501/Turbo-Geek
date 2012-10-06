var express = require('express');
var app = express();
var mysql = require('mysql');
var _ = require('underscore')._;

// Express Configuration
app.configure(function(){
    'use strict';
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(function (req,res,next) {
        res.header('Access-Control-Allow-Origin', '*');
        res.header('Access-Control-Allow-Headers', 'X-Requested-With');
        res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS');
        res.header('Access-Control-Allow-Headers', 'Content-Type');
        next();
    });
    app.use(app.router);
    app.use(express.static(__dirname + '/yeoman/dist'));
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('development', function(){
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
});


//Routes
app.get('/comics',function(req,res){
    var connection = mysql.createConnection({
        host     : 'localhost',
        user     : 'root',
        password : '',
        database : 'Turbo'
    });

    connection.query('CALL GetComics("1")', function(err, rows, fields) {
        if (err) throw err;

        _.each(rows[0], function(row){
            if(row.IsMine == '1'){
                row.IsMine = true;
            } else if(row.IsMine == '0') {
                row.IsMine = false;
            }
        });

        res.send(rows[0]);
    });
});

app.post('/subscribe/:id',function(req,res){
    var connection = mysql.createConnection({
        host     : 'localhost',
        user     : 'root',
        password : '',
        database : 'Turbo'
    });

    connection.query('CALL Subscribe(1 , ?)', [req.params.id], function(err, rows, fields) {
        if (err) throw err;

        res.send({msg: 'OK'});
    });
});

app.delete('/subscribe/:id',function(req,res){
    var connection = mysql.createConnection({
        host     : 'localhost',
        user     : 'root',
        password : '',
        database : 'Turbo'
    });

    connection.query('CALL Unsubscribe(1 , ?)', [req.params.id], function(err, rows, fields) {
        if (err) throw err;

        res.send({msg: 'OK'});
    });
});

app.listen(process.env.C9_PORT || process.env.PORT || 5000);
console.log("Express server listening on port %d", process.env.C9_PORT || process.env.PORT || 5000);