(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, Backbone, ComicsView, PageView, TurboGeek;
    $ = require('jquery');
    Backbone = require('backbone');
    PageView = require('views/Page');
    ComicsView = require('views/Comics');
    return TurboGeek = (function(_super) {

      __extends(TurboGeek, _super);

      function TurboGeek() {
        return TurboGeek.__super__.constructor.apply(this, arguments);
      }

      TurboGeek.prototype.routes = {
        '': 'index'
      };

      TurboGeek.prototype.initialize = function() {
        this.pageView = new PageView();
        return this.pageView.render();
      };

      TurboGeek.prototype.updateContent = function() {
        return this.pageView.$('.content').html(this.currentView.render().el);
      };

      TurboGeek.prototype.index = function() {
        this.currentView = new ComicsView();
        return this.updateContent();
      };

      return TurboGeek;

    })(Backbone.Router);
  });

}).call(this);
