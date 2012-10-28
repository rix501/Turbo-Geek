crypto = require 'crypto'
connect = require 'connect'
express = require 'express'
app = express()

_ = require('underscore')._

Comics = require './modules/models/comics'
User = require './modules/models/user'

rewrite = (req,res,next) ->
    isRoute = no
    routes = _.chain(value for own key, value of app.routes).union().flatten().value()
    isRoute = _.find routes, (route) -> route.regexp.test req.url

    unless isRoute
        match = /^\/([a-z0-9\/]+)(?![^\.]{1}[^a-z0-9]+)$/i.exec req.url 
        req.url = "/index.html##{match[1]}" if match?

    next()

syfo = (token, saif) ->
    algo = 'aes192'
    secret = 'g33kturb0'
    if saif
        cipher = crypto.createCipher(algo, secret)
        inputFmt = 'utf8'
        outFmt = 'base64'
    else 
        cipher = crypto.createDecipher(algo, secret)
        inputFmt = 'base64'
        outFmt = 'utf8'

    cipher.update(token, inputFmt, outFmt) + cipher.final(outFmt)


checkUser = (username, password, cb) ->
    user = new User 
    user.getUser username, => 

        if user.id? and username is user.get('username') and password is user.get('password')
            auth = true
            cb auth, user
        else 
            auth = false
            cb auth

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
    app.use express.static "#{__dirname}/public/dist"

#Routes

app.post '/login', (req,res) ->
    checkUser req.body.username, req.body.password, (auth, user) ->
        if auth
            res.send token: syfo("#{user.id}", true)
        else 
            res.send 400, status: 'error'


app.get /^\/comics\/?(new|all|you)?$/, (req,res) ->
    if req.params[0]? then type = req.params[0] else type = 'all'

    comics = new Comics

    comics.userId = syfo(req.query.token) if req.query.token

    if type is 'all'
        comics.getAllComics
            success: ->
                res.send comics.toJSON()
    else if type is 'new'
        comics.getNewComics
            success: ->
                res.send comics.toJSON()
    else if type is 'you'
        if comics.userId?
            comics.getUserComics
                success: ->
                    res.send comics.toJSON()
        else
            res.send 403, error: 'Need to authenticate'



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