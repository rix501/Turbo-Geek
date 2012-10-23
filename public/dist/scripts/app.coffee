define (require) ->
    
    $ = require 'jquery'
    Backbone = require 'backbone'

    PageView = require 'views/Page'
    {ComicsView, NewComicsView, AllComicsView} = require 'views/Comics'

    class TurboGeek extends Backbone.Router
        routes: 
            '' : 'index'
            'new' : 'index'
            'all' : 'all'

        initialize: ->
            @pageView = new PageView()
            @pageView.render()

        updateContent: (nav) ->
            @pageView.$('.content').html @currentView.render().el

            @pageView.changeNav nav if nav   

        index: ->
            @currentView = new NewComicsView()
            @updateContent('new')

        all: ->
            @currentView = new AllComicsView()
            @updateContent('all')