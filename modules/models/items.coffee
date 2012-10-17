_ = require('underscore')._
Backbone = require 'backbone'

Item = require './item'
    
class Items extends Backbone.Collection
	initialize: () ->

    model: Item

module.exports = Items