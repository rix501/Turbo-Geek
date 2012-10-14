define (require, exports) ->

    Comic = require 'models/comic'
    Backbone = require 'backbone'

    class Comics extends Backbone.Collection
        initialize: ->
            _.extend @, @options

        model: Comic

        recent: false

        url: ->
            if @recent
                '/comics'
            else
                '/comics'

        comparator: (model) ->
        	model.get 'name'

        getNewComics: ->
        	now = moment()

        	@filter (model) ->
    	        now.format('YYYY-MM-DD') is model.get('lastUpdated').format('YYYY-MM-DD')