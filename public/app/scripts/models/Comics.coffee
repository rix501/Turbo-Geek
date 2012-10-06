define [
    'models/comic',
    'backbone'
],
(Comic) ->
    Backbone.Collection.extend
        model: Comic
        url: 'http://localhost:5000/comics'
