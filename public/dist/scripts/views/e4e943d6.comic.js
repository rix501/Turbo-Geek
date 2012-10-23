(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, COMIC_TEMPLATE, ComicView, Mustache;
    Mustache = require('mustache');
    Backbone = require('backbone');
    COMIC_TEMPLATE = require('text!tmpl/comic.mustache');
    return ComicView = (function(_super) {

      __extends(ComicView, _super);

      function ComicView() {
        return ComicView.__super__.constructor.apply(this, arguments);
      }

      ComicView.prototype.template = Mustache.compile(COMIC_TEMPLATE);

      ComicView.prototype.events = {
        'click a.subscribe': 'subscribe',
        'click a.unsubscribe': 'unsubscribe'
      };

      ComicView.prototype.tagName = 'li';

      ComicView.prototype.className = 'comic well';

      ComicView.prototype.initialize = function() {
        return this.model.on('change:isMine', this.render, this);
      };

      ComicView.prototype.subscribe = function(event) {
        event.preventDefault();
        this.model.subscribe();
        return false;
      };

      ComicView.prototype.unsubscribe = function(event) {
        event.preventDefault();
        this.model.unsubscribe();
        return false;
      };

      ComicView.prototype.render = function() {
        this.$el.addClass('comic-' + this.model.id);
        this.$el.html(this.template(this.model.toJSON()));
        return this;
      };

      return ComicView;

    })(Backbone.View);
  });

}).call(this);
