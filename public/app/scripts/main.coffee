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

    webserviceUrl = (path) ->
        return unless path

        if window.location.href.indexOf('localhost') > 0
            host = 'http://localhost:5000'
        else
            host = ''

        "#{host}#{path}"

    getValue = (object, prop) ->
        return null  if !(object and object[prop])
        if _.isFunction(object[prop]) then object[prop]() else object[prop]

    Backbone.sync = (method, model, options = {}) ->
        # all model/collection urls get webservice base prefix
        options.url ?= getValue model, 'url'
        options.url = options.url() if _.isFunction(options.url)

        options.url = webserviceUrl(options.url)

        sync method, model, options
    
    $ ->
        window.App = new TurboGeek()
        Backbone.history.start()