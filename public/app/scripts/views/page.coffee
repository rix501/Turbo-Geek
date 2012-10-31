define (require) ->
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Bootstrap = require 'bootstrap'

    Viewer = require 'models/user'

    SignupModal = require 'views/signup-modal'

    PAGE_TEMPLATE = require 'text!tmpl/page.mustache'

    class PageView extends Backbone.View

        template: Mustache.compile PAGE_TEMPLATE

        el: 'body'

        events: 
            'submit #login-form' : 'login'
            'click .logout' : 'logout'
            'click #signup' : 'signup'

        changeNav: (navClass) ->
            @$(".nav .active").removeClass 'active'
            @$(".nav .#{navClass}").addClass 'active'


        login: (e) ->
            e.preventDefault()
            Viewer.login(@$('#login-form input[name="username"]').val(), @$('#login-form input[name="password"]').val())
            Viewer.on 'login', @render
            
        logout: (e) ->
            e.preventDefault()
            Viewer.logout()
            Viewer.on 'logout', @render

        signup: (e) ->
            e.preventDefault()
            modal = new SignupModal
                close: =>
                    @render() if Viewer.isLoggedIn()
            modal.render()


        render: =>
            viewer = Viewer.toJSON() if Viewer.isLoggedIn()

            @$el.html @template(viewer: viewer) 

            @