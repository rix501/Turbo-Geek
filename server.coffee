express = require 'express'
app = express()

Comics = require './modules/models/comics'

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
    app.use express.errorHandler dumpExceptions: false, showStack: false

app.configure ->
    app.use express.bodyParser() 
    app.use express.methodOverride()
    app.use app.router
    app.use express.static __dirname + '/public/dist/'

#Routes
app.get /^\/comics\/?(new|all|you)?$/, (req,res) ->
    if req.params[0]? then type = req.params[0] else type = 'all'

    console.log type, req.params

    comics = new Comics

    if type is 'all'
        comics.getAllComics
            success: ->
                res.send comics.toJSON()
    else if type is 'new'
        comics.getNewComics
            success: ->
                res.send comics.toJSON()



app.get '/fire', (req, res) ->
    comics = new Comics
    comics.updateComics (msg) -> res.send msg


# app.post('/subscribe/:id',function(req,res){

#     connection.query('CALL Subscribe(1 , ?)', [req.params.id], function(err, rows, fields) {
#         if (err) throw err

#         res.send({msg: 'OK'})
#     })
# })

# app.delete('/subscribe/:id',function(req,res){

#     connection.query('CALL Unsubscribe(1 , ?)', [req.params.id], function(err, rows, fields) {
#         if (err) throw err

#         res.send({msg: 'OK'})
#     })
# })

app.listen process.env.C9_PORT || process.env.PORT || 5000
console.log 'Express server listening on port %d', process.env.C9_PORT || process.env.PORT || 5000