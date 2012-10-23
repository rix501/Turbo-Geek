(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var $, AllComicsView, Backbone, ComicsView, NewComicsView, PageView, TurboGeek, _ref;
    $ = require('jquery');
    Backbone = require('backbone');
    PageView = require('views/Page');
    _ref = require('views/Comics'), ComicsView = _ref.ComicsView, NewComicsView = _ref.NewComicsView, AllComicsView = _ref.AllComicsView;
    return TurboGeek = (function(_super) {

      __extends(TurboGeek, _super);

      function TurboGeek() {
        return TurboGeek.__super__.constructor.apply(this, arguments);
      }

      TurboGeek.prototype.routes = {
        '': 'index',
        'new': 'index',
        'all': 'all'
      };

      TurboGeek.prototype.initialize = function() {
        this.pageView = new PageView();
        return this.pageView.render();
      };

      TurboGeek.prototype.updateContent = function(nav) {
        this.pageView.$('.content').html(this.currentView.render().el);
        if (nav) {
          return this.pageView.changeNav(nav);
        }
      };

      TurboGeek.prototype.index = function() {
        this.currentView = new NewComicsView();
        return this.updateContent('new');
      };

      TurboGeek.prototype.all = function() {
        this.currentView = new AllComicsView();
        return this.updateContent('all');
      };

      return TurboGeek;

    })(Backbone.Router);
  });

}).call(this);
