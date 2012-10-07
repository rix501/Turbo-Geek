define (require) ->

    Comic = require 'models/comic'
    Backbone = require 'backbone'

    class Comics extends Backbone.Collection
        model: Comic
        url: 'http://localhost:5000/comics'
