(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports) {
    var Backbone, Comic, Comics, _;
    Comic = require('models/comic');
    Backbone = require('backbone');
    _ = require('underscore');
    return Comics = (function(_super) {

      __extends(Comics, _super);

      function Comics() {
        return Comics.__super__.constructor.apply(this, arguments);
      }

      Comics.prototype.model = Comic;

      Comics.prototype.defaults = {
        type: ''
      };

      Comics.prototype.initialize = function(options) {
        _.extend(this, options);
        return _.defaults(this, this.defaults);
      };

      Comics.prototype.url = function() {
        return "/comics/" + this.type;
      };

      Comics.prototype.comparator = function(model) {
        return model.get('name');
      };

      Comics.prototype.getNewComics = function() {
        var now;
        now = moment();
        return this.filter(function(model) {
          return now.format('YYYY-MM-DD') === model.get('lastUpdated').format('YYYY-MM-DD');
        });
      };

      return Comics;

    })(Backbone.Collection);
  });

}).call(this);
