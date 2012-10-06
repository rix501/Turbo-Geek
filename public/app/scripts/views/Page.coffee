define [
    'mustache',
    'backbone'
],
(Mustache) ->
    Backbone.View.extend
        template: Mustache.compile($("#page-template").html())
        el: 'body'
        initialize: ->
            _.bindAll @, 'render'
        render: ->
            @$el.html @template() 

            @