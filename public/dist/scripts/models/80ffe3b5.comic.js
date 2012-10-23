(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports) {
    var Backbone, Comic, moment;
    Backbone = require('backbone');
    moment = require('moment');
    return Comic = (function(_super) {

      __extends(Comic, _super);

      function Comic() {
        return Comic.__super__.constructor.apply(this, arguments);
      }

      Comic.prototype.initialize = function() {
        this.set({
          lastUpdated: moment.utc(this.get('lastUpdated'))
        });
        return this.set({
          lastUpdatedFormated: this.get('lastUpdated').fromNow()
        });
      };

      Comic.prototype.subscribe = function() {
        var req,
          _this = this;
        req = $.ajax({
          url: 'http://localhost:5000/subscribe/' + this.id,
          type: 'POST'
        });
        return req.then(function() {
          return _this.set({
            isMine: true
          });
        });
      };

      Comic.prototype.unsubscribe = function() {
        var req,
          _this = this;
        req = $.ajax({
          url: 'http://localhost:5000/subscribe/' + this.id,
          type: 'DELETE'
        });
        return req.then(function() {
          return _this.set({
            isMine: false
          });
        });
      };

      return Comic;

    })(Backbone.Model);
  });

}).call(this);
