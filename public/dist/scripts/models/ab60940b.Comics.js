(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, Comic, Comics;
    Comic = require('models/comic');
    Backbone = require('backbone');
    return Comics = (function(_super) {

      __extends(Comics, _super);

      function Comics() {
        return Comics.__super__.constructor.apply(this, arguments);
      }

      Comics.prototype.model = Comic;

      Comics.prototype.url = '/comics';

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
