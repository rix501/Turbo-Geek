(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, COMICS_TEMPLATE, ComicView, Comics, ComicsView, Mustache;
    Mustache = require('mustache');
    Backbone = require('backbone');
    Comics = require('models/Comics');
    ComicView = require('views/Comic');
    COMICS_TEMPLATE = require('text!tmpl/comics.mustache');
    return ComicsView = (function(_super) {

      __extends(ComicsView, _super);

      function ComicsView() {
        return ComicsView.__super__.constructor.apply(this, arguments);
      }

      ComicsView.prototype.template = Mustache.compile(COMICS_TEMPLATE);

      ComicsView.prototype.initialize = function() {
        this.collection = new Comics();
        this.collection.bind('reset', this.addAll, this);
        return this.collection.fetch();
      };

      ComicsView.prototype.add = function(model, group) {
        var comicView, el;
        comicView = new ComicView({
          model: model
        });
        el = comicView.render().el;
        return this.$('ul.' + group).append(el);
      };

      ComicsView.prototype.addAll = function(collection) {
        var newComics,
          _this = this;
        newComics = collection.getNewComics();
        _.each(newComics, function(model) {
          return _this.add(model, 'new-comics');
        });
        return collection.each(function(model) {
          return _this.add(model, 'comics');
        });
      };

      ComicsView.prototype.render = function() {
        this.$el.html(this.template());
        return this;
      };

      return ComicsView;

    })(Backbone.View);
  });

}).call(this);
