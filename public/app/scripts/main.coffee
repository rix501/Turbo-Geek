require.config 
    paths: 
        'jquery': 'vendor/jquery.min'
        'underscore': 'vendor/underscore.min'
        'backbone': 'vendor/backbone.min'
        'mustache':'vendor/mustache'
        'bootstrap': 'vendor/bootstrap.min'
        'moment': 'vendor/moment.min'
        'text': 'vendor/text'
        'tmpl': '../templates'
    shim:
        'underscore':
            exports: '_'
        'backbone':
            deps: ['underscore', 'jquery']
            exports: 'Backbone'
        'bootstrap' : ['jquery']

define (require) ->
    $ = require 'jquery'
    Backbone = require 'backbone'

    TurboGeek = require 'app'

    sync = Backbone.sync

    Backbone.emulateJSON = true

    webserviceUrl = (path) ->
        return unless path

        regx = /^http:\/\/(10\.0\.1\.[0-9]{1,2}|localhost):[0-9]{2,4}.*/

        host = regx.exec(window.location.href)

        if host? and host.length > 1
            host = "http://#{host[1]}:5000"
        else
            host = ''

        "#{host}#{path}"

    getValue = (object, prop) ->
        return null  if !(object and object[prop])
        if _.isFunction(object[prop]) then object[prop]() else object[prop]

    Backbone.sync = (method, model, options = {}) ->
        options.url ?= getValue model, 'url'
        options.url = options.url() if _.isFunction(options.url)

        options.url = webserviceUrl(options.url)

        if !options.data && model && (method == 'create' || method == 'update')
            options.data = {}
            options.data = model.toJSON()

        options.data ?= {}    
        options.data.token = 'Tyw6fZrrHXymNUyewA2dKA==' if true #user.token

        sync method, model, options
    
    $ ->
        window.App = new TurboGeek()
        Backbone.history.start( pushState: true)