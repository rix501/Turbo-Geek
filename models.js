var _ = require('underscore')._;
var Backbone = require('backbone');

var Models = {};

Models.Comic = Backbone.Model.extend({
    
});

Models.Comics = Backbone.Collection.extend({
    model: Models.Comic
});

module.exports = Models;