(function() {

  require.config({
    paths: {
      'jquery': 'vendor/jquery.min',
      'underscore': 'vendor/underscore.min',
      'backbone': 'vendor/backbone.min',
      'mustache': 'vendor/mustache',
      'bootstrap': 'vendor/bootstrap.min',
      'moment': 'vendor/moment.min',
      'text': 'vendor/text',
      'tmpl': '../templates'
    },
    shim: {
      'underscore': {
        exports: '_'
      },
      'backbone': {
        deps: ['underscore', 'jquery'],
        exports: 'Backbone'
      },
      'bootstrap': ['jquery']
    }
  });

  define(function(require) {
    var $, Backbone, TurboGeek, getValue, sync, webserviceUrl;
    $ = require('jquery');
    Backbone = require('backbone');
    TurboGeek = require('app');
    sync = Backbone.sync;
    webserviceUrl = function(path) {
      var host, regx;
      if (!path) {
        return;
      }
      regx = /^http:\/\/(10\.0\.1\.[0-9]{1,2}|localhost):[0-9]{2,4}.*/;
      host = regx.exec(window.location.href);
      if ((host != null) && host.length > 1) {
        host = "http://" + host[1] + ":5000";
      } else {
        host = '';
      }
      return "" + host + path;
    };
    getValue = function(object, prop) {
      if (!(object && object[prop])) {
        return null;
      }
      if (_.isFunction(object[prop])) {
        return object[prop]();
      } else {
        return object[prop];
      }
    };
    Backbone.sync = function(method, model, options) {
      var _ref;
      if (options == null) {
        options = {};
      }
      if ((_ref = options.url) == null) {
        options.url = getValue(model, 'url');
      }
      if (_.isFunction(options.url)) {
        options.url = options.url();
      }
      options.url = webserviceUrl(options.url);
      return sync(method, model, options);
    };
    return $(function() {
      window.App = new TurboGeek();
      return Backbone.history.start();
    });
  });

}).call(this);
