define (require, exports) ->

    Comic = require 'models/comic'
    Backbone = require 'backbone'
    _ = require 'underscore'

    class Comics extends Backbone.Collection
       
        model: Comic

        defaults:
            type: ''

        initialize: (options) ->
            _.extend @, options
            _.defaults @, @defaults

        url: ->
            "/comics/#{@type}"
        
        comparator: (model) ->
        	model.get 'name'

        getNewComics: ->
        	now = moment()

        	@filter (model) ->
    	        now.format('YYYY-MM-DD') is model.get('lastUpdated').format('YYYY-MM-DD')