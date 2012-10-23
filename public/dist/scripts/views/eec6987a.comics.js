(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports) {
    var AllComicsView, Backbone, COMICS_TEMPLATE, ComicView, Comics, ComicsView, Mustache, NewComicsView;
    Mustache = require('mustache');
    Backbone = require('backbone');
    Comics = require('models/Comics');
    ComicView = require('views/Comic');
    COMICS_TEMPLATE = require('text!tmpl/comics.mustache');
    ComicsView = (function(_super) {

      __extends(ComicsView, _super);

      function ComicsView() {
        this.addAll = __bind(this.addAll, this);
        return ComicsView.__super__.constructor.apply(this, arguments);
      }

      ComicsView.prototype.header = 'Comics';

      ComicsView.prototype.template = Mustache.compile(COMICS_TEMPLATE);

      ComicsView.prototype.initialize = function(options) {
        this.comics = new Comics();
        return this.comics.on('reset', this.addAll, this);
      };

      ComicsView.prototype.add = function(model) {
        var comicView;
        comicView = new ComicView({
          model: model
        });
        return this.$comics.append(comicView.render().el);
      };

      ComicsView.prototype.addAll = function(collection) {
        return collection.each(this.add, this);
      };

      ComicsView.prototype.render = function() {
        this.$el.html(this.template({
          header: this.header
        }));
        this.$comics = this.$('ul.comics');
        return this;
      };

      return ComicsView;

    })(Backbone.View);
    NewComicsView = (function(_super) {

      __extends(NewComicsView, _super);

      function NewComicsView() {
        return NewComicsView.__super__.constructor.apply(this, arguments);
      }

      NewComicsView.prototype.header = 'Today\'s New Comics';

      NewComicsView.prototype.initialize = function() {
        NewComicsView.__super__.initialize.apply(this, arguments);
        this.comics.type = 'new';
        return this.comics.fetch();
      };

      return NewComicsView;

    })(ComicsView);
    AllComicsView = (function(_super) {

      __extends(AllComicsView, _super);

      function AllComicsView() {
        return AllComicsView.__super__.constructor.apply(this, arguments);
      }

      AllComicsView.prototype.header = 'All Comics';

      AllComicsView.prototype.initialize = function() {
        AllComicsView.__super__.initialize.apply(this, arguments);
        this.comics.type = 'all';
        return this.comics.fetch();
      };

      return AllComicsView;

    })(ComicsView);
    exports.ComicsView = ComicsView;
    exports.NewComicsView = NewComicsView;
    exports.AllComicsView = AllComicsView;
    return exports;
  });

}).call(this);
