define (require) ->
    Mustache = require 'mustache'
    Backbone = require 'backbone'

    PAGE_TEMPLATE = require 'text!tmpl/page.mustache'

    class PageView extends Backbone.View
        template: Mustache.compile PAGE_TEMPLATE
        el: 'body'
        initialize: ->
            _.bindAll @, 'render'
        render: ->
            @$el.html @template() 

            @