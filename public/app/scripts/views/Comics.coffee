define (require, exports) ->

    Mustache = require 'mustache'
    Backbone = require 'backbone'

    Comics = require 'models/Comics'
    ComicView = require 'views/Comic'

    COMICS_TEMPLATE = require 'text!tmpl/comics.mustache'

    class ComicsView extends Backbone.View
        header: 'Comics'
        template: Mustache.compile COMICS_TEMPLATE
        initialize: ->
            @collection.bind 'reset', @addAll, @
            @collection.fetch()

        add: (model) ->
            comicView = new ComicView model: model
            @$('ul.comics').append comicView.render().el 

        addAll: (collection) ->
            collection.each (model) =>  @add model

        render: ->
            @$el.html(@template(header: @header))
            @

    class NewComicsView extends ComicsView
        header: 'Today\'s New Comics'

        initialize: ->
            @collection = new Comics(recent: true)
            super

        addAll: (collection) ->
            _.each collection.getNewComics(), (model) => @add model

    class AllComicsView extends ComicsView
        header: 'All Comics'

        initialize: ->
            @collection = new Comics()
            super

    exports.ComicsView = ComicsView
    exports.NewComicsView = NewComicsView
    exports.AllComicsView = AllComicsView

    exports