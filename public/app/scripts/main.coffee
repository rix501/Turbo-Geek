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
    
    $ ->
        window.App = new TurboGeek()
        Backbone.history.start()