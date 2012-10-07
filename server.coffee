express = require 'express'
app = express()
mysql = require 'mysql'
_ = require('underscore')._
torpedo = require './torpedo'

# Express Configuration
app.configure 'development', ->
    app.use (req,res,next) ->
        res.header 'Access-Control-Allow-Origin', '*'
        res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
        res.header 'Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS'
        res.header 'Access-Control-Allow-Headers', 'Content-Type'
        next()
    app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->

app.configure ->
    app.use express.bodyParser() 
    app.use express.methodOverride()
    app.use app.router
    app.use express.static __dirname + '/public/dist'
    app.use express.errorHandler dumpExceptions: true, showStack: true

#Routes
app.get '/comics', (req,res) ->
    connection = mysql.createConnection
        host     : 'localhost'
        user     : 'root'
        password : ''
        database : 'Turbo'
    
    connection.query 'SELECT * FROM all_comics', (err, rows, fields) ->
        if err then throw err
            
        res.send rows

app.get '/fire', (req, res) ->
    torpedo.fire (msg) -> res.send msg


# app.post('/subscribe/:id',function(req,res){
#     var connection = mysql.createConnection({
#         host     : 'localhost',
#         user     : 'root',
#         password : '',
#         database : 'Turbo'
#     })

#     connection.query('CALL Subscribe(1 , ?)', [req.params.id], function(err, rows, fields) {
#         if (err) throw err

#         res.send({msg: 'OK'})
#     })
# })

# app.delete('/subscribe/:id',function(req,res){
#     var connection = mysql.createConnection({
#         host     : 'localhost',
#         user     : 'root',
#         password : '',
#         database : 'Turbo'
#     })

#     connection.query('CALL Unsubscribe(1 , ?)', [req.params.id], function(err, rows, fields) {
#         if (err) throw err

#         res.send({msg: 'OK'})
#     })
# })


app.listen process.env.C9_PORT || process.env.PORT || 5000
console.log 'Express server listening on port %d', process.env.C9_PORT || process.env.PORT || 5000