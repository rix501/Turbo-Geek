define (require) ->

    Mustache = require 'mustache'
    Backbone = require 'backbone'

    Comics = require 'models/Comics'
    ComicView = require 'views/Comic'

    COMICS_TEMPLATE = require 'text!tmpl/comics.mustache'

    class ComicsView extends Backbone.View
        template: Mustache.compile COMICS_TEMPLATE
        initialize: ->
            @collection = new Comics()
            @collection.bind 'reset', @addAll, @

            @collection.fetch()

        add: (model, group) ->
            comicView = new ComicView model: model

            el = comicView.render().el
            @$('ul.' + group).append el 

        addAll: (collection) ->
            newComics = collection.getNewComics()

            _.each newComics, (model) => @add model, 'new-comics'

            collection.each (model) =>  @add model, 'comics'

        render: ->
            @$el.html(@template())
            @