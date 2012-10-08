define (require) ->
    
    Backbone = require 'backbone'
    moment = require 'moment'

    class Comic extends Backbone.Model
        initialize: ->
            @set lastUpdated: moment @get('lastUpdated')
            @set lastUpdatedFormated: @get('lastUpdated').fromNow()

        subscribe: ->
            req = $.ajax
                url: 'http://localhost:5000/subscribe/' + @id
                type: 'POST'
            
            req.then =>
                @set
                    IsMine: true

        unsubscribe: ->
            req = $.ajax
                url: 'http://localhost:5000/subscribe/' + @id
                type: 'DELETE'

            req.then =>
                @set
                    IsMine: false