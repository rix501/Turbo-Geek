define (require, exports) ->
    
    Backbone = require 'backbone'
    moment = require 'moment'
    store = require 'models/store'

    class User extends Backbone.Model

        initialize: ->
            @on 'change', (model, resp) =>
                if @isLoggedIn()
                    store.set 'viewer', model.toJSON()

        isLoggedIn: ->
            !!@get('token')


        login: (username, password) ->
            url = @url
            @url = '/login'

            @save { username: username, password: password } ,
                success: (model) => 
                    @url = url
                    @trigger 'login'

        logout: ->
            _.defer =>
                @trigger 'logout' 
                store.remove 'viewer'
            @clear()


        subscribe: ->
            req = $.ajax
                url: 'http://localhost:5000/subscribe/' + @id
                type: 'POST'
            
            req.then =>
                @set
                    isMine: true

        unsubscribe: ->
            req = $.ajax
                url: 'http://localhost:5000/subscribe/' + @id
                type: 'DELETE'

            req.then =>
                @set
                    isMine: false

    window.viewer = new User store.get('viewer')

    window.viewer