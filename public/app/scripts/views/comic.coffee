define (require) ->

    Mustache = require 'mustache'
    Backbone = require 'backbone'

    COMIC_TEMPLATE = require 'text!tmpl/comic.mustache'

    class ComicView extends Backbone.View
        template: Mustache.compile COMIC_TEMPLATE

        events: 
            'click a.subscribe' : 'subscribe'
            'click a.unsubscribe' : 'unsubscribe'

        tagName: 'li'

        className: 'comic well span3'

        initialize: ->
            @model.on 'change:isMine', @render, @

        subscribe: (event) ->
            event.preventDefault()
            @model.subscribe()
            false

        unsubscribe: (event) ->
            event.preventDefault()
            @model.unsubscribe()
            false

        render: ->
            @$el.addClass 'comic-' + @model.id
            @$el.html @template @model.toJSON()
            @