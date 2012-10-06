require.config 
    paths: 
        'jquery': 'vendor/jquery.min',
        'underscore': 'vendor/underscore.min',
        'backbone': 'vendor/backbone.min',
        'mustache':'vendor/mustache',
        'bootstrap': 'vendor/bootstrap.min'
    shim:
        'underscore':
            exports: '_'
        'backbone':
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        'bootstrap' : ['jquery']

require ['app'],
(TurboGeek) ->
    $ ->
        window.App = new TurboGeek()
        Backbone.history.start()