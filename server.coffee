connect = require 'connect'
express = require 'express'
app = express()

_ = require('underscore')._

Comics = require './modules/models/comics'


rewrite = (req,res,next) ->
    isRoute = no
    routes = _.chain(value for own key, value of app.routes).union().flatten().value()
    isRoute = _.find routes, (route) -> route.regexp.test req.url

    unless isRoute
        match = /^\/([a-z0-9\/]+)(?![^\.]{1}[^a-z0-9]+)$/i.exec req.url 
        req.url = "/index.html##{match[1]}" if match?

    next()

checkAuth = (req, res, next) ->
    if app.settings.env is 'development'
        req.session.auth = true
    
    if req.url is '/login'
        if req.session and req.session.auth
            res.redirect '/'
        else 
            next()
        
        return
    
    if req.session and req.session.auth
        next()
        return
    
    if typeof req.headers['x-requested-with'] isnt 'undefined'
        res.send error: 'access denied', 403
    else
        res.redirect '/login'


checkUser = (username, password, cb) ->
    auth = false
    
    users.forEach (user) ->
        if username is user.username and password is user.password
            auth = true
            cb auth, user

    if not !auth then cb auth

staticMiddleware = express.static "#{__dirname}/public/dist"

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
    app.use connect.compress() 
    app.use rewrite
    app.use staticMiddleware

#Routes

app.post '/login', (req,res) ->
    checkUser req.body.username, req.body.password, (auth, user) ->
        if auth
            req.session.auth = true;
            res.send({status: 'ok'});
        else 
            res.send({status: 'ok'}, 400);


app.get /^\/comics\/?(new|all|you)?$/, (req,res) ->
    if req.params[0]? then type = req.params[0] else type = 'all'

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