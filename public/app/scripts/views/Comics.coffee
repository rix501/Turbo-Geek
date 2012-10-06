define [
    'models/Comics',
    'views/Comic',
    'mustache',
    'backbone'
],
(Comics, ComicView, Mustache) ->
    Backbone.View.extend
        template: Mustache.compile $("#comics-template").html()
        initialize: ->
            @collection = new Comics()
            @collection.bind 'reset', @addAll, @
            @collection.bind 'change:IsMine', (model, IsMine) ->
                if IsMine then @add model, 'my-comics' else @$('.my-comics .comic-' + model.id).remove()
            , @

            @collection.fetch()

        add: (model, group) ->
            comicView = new ComicView
                model: model

            el = comicView.render().el
            @$('ul.' + group).append el 

        addAll: (collection) ->
            myComics = collection.filter (model) ->
                model.get 'IsMine'

            _.each myComics, (model) =>
                @add model, 'my-comics'

            collection.each (model) => 
                @add model, 'comics'

        render: ->
            @$el.html(@template())
            @