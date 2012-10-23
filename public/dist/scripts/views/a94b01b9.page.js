(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, Bootstrap, Mustache, PAGE_TEMPLATE, PageView;
    Mustache = require('mustache');
    Backbone = require('backbone');
    Bootstrap = require('bootstrap');
    PAGE_TEMPLATE = require('text!tmpl/page.mustache');
    return PageView = (function(_super) {

      __extends(PageView, _super);

      function PageView() {
        this.render = __bind(this.render, this);
        return PageView.__super__.constructor.apply(this, arguments);
      }

      PageView.prototype.template = Mustache.compile(PAGE_TEMPLATE);

      PageView.prototype.el = 'body';

      PageView.prototype.changeNav = function(navClass) {
        this.$(".nav .active").removeClass('active');
        return this.$(".nav ." + navClass).addClass('active');
      };

      PageView.prototype.render = function() {
        this.$el.html(this.template());
        return this;
      };

      return PageView;

    })(Backbone.View);
  });

}).call(this);
