define [
    'mustache',
    'backbone'
],
(Mustache) ->
    Backbone.View.extend
        template: Mustache.compile $("#comic-template").html()
        events: 
            'click a.subscribe' : 'subscribe'
            'click a.unsubscribe' : 'unsubscribe'
        tagName: 'li'
        className: 'comic'
        initialize: ->
            @model.bind 'change:IsMine', @render, @

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