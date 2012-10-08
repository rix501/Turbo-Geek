define (require) ->
    
    $ = require 'jquery'
    Backbone = require 'backbone'

    PageView = require 'views/Page'
    ComicsView = require 'views/Comics'

    class TurboGeek extends Backbone.Router
        routes: 
            '' : 'index'

        initialize: ->
            @pageView = new PageView()
            @pageView.render()

        updateContent: ->
            @pageView.$('.content').html @currentView.render().el

        index: ->
            @currentView = new ComicsView()
            @updateContent()