define [
    'views/Page',
    'views/Comics',
    'jquery',
    'underscore',
    'backbone',
    'bootstrap'
],
(PageView, ComicsView) ->
    Backbone.Router.extend 
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
        