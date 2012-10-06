define [
    'backbone'
],
->
    Backbone.Model.extend
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