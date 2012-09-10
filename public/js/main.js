require.config({
    paths: {
        "jquery": "vendor/jquery.min",
        "underscore": "vendor/underscore.min",
        "backbone": "vendor/backbone.min",
        "mustache":"vendor/mustache"
    },
    shim: {
        "underscore": {
            exports: '_'
        },
        "backbone": {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        }
    }
});

require(['app'],
function(TurboGeek) {
    $(function() {
        window.App = new TurboGeek();
        Backbone.history.start();
    });
});