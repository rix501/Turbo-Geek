define (require) ->
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Bootstrap = require 'bootstrap'

    PAGE_TEMPLATE = require 'text!tmpl/page.mustache'

    class PageView extends Backbone.View

        template: Mustache.compile PAGE_TEMPLATE

        el: 'body'

        events: 
            'submit #login-form' : 'login'

        changeNav: (navClass) ->
            @$(".nav .active").removeClass 'active'
            @$(".nav .#{navClass}").addClass 'active'


        login: (e) ->
            e.preventDefault()
            user = new Backbone.Model()
            user.url = '/login'

            user.save { username: 'rix501', password: 'rix' } ,
                success: (t, x) -> console.log t, x
            


        render: =>
            @$el.html @template() 

            @