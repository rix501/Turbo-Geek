define (require) ->

    Comic = require 'models/comic'
    Backbone = require 'backbone'

    class Comics extends Backbone.Collection
        model: Comic

        url: '/comics'

        comparator: (model) ->
        	model.get 'name'

        getNewComics: ->
        	now = moment()

        	@filter (model) ->
    	        now.format('YYYY-MM-DD') is model.get('lastUpdated').format('YYYY-MM-DD')

