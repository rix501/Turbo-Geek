define (require) ->
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Bootstrap = require 'bootstrap'

    PAGE_TEMPLATE = require 'text!tmpl/page.mustache'

    class PageView extends Backbone.View

        template: Mustache.compile PAGE_TEMPLATE

        el: 'body'

        changeNav: (navClass) ->
            @$(".nav .active").removeClass 'active'
            @$(".nav .#{navClass}").addClass 'active'

        render: =>
            @$el.html @template() 

            @