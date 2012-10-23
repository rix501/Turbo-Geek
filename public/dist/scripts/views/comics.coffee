define (require, exports) ->

    Mustache = require 'mustache'
    Backbone = require 'backbone'

    Comics = require 'models/Comics'
    ComicView = require 'views/Comic'

    COMICS_TEMPLATE = require 'text!tmpl/comics.mustache'

    class ComicsView extends Backbone.View

        header: 'Comics'

        template: Mustache.compile COMICS_TEMPLATE

        initialize: (options) ->
            @comics = new Comics() 
            @comics.on 'reset', @addAll, @

        add: (model) ->
            comicView = new ComicView model: model
            @$comics.append comicView.render().el 

        addAll: (collection) =>
            collection.each @add, @

        render: ->
            @$el.html @template(header: @header)
            @$comics = @$('ul.comics')
            @

    class NewComicsView extends ComicsView

        header: 'Today\'s New Comics'

        initialize: ->
            super
            @comics.type = 'new'
            @comics.fetch()
            
    class AllComicsView extends ComicsView

        header: 'All Comics'

        initialize: ->
            super
            @comics.type = 'all'
            @comics.fetch()

    exports.ComicsView = ComicsView
    exports.NewComicsView = NewComicsView
    exports.AllComicsView = AllComicsView

    exports