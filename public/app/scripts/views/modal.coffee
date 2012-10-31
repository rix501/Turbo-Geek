define (require) ->
    Mustache = require 'mustache'
    _ = require 'underscore'
    Backbone = require 'backbone'
    Bootstrap = require 'bootstrap'

    MODAL_TEMPLATE = require 'text!tmpl/modal.mustache'

    class Modal extends Backbone.View

        template: MODAL_TEMPLATE

        tagName: 'div'
        className: 'modal fade'

        events: 
            'hidden' : 'remove'

        initialize: (options) ->
            _.extend @, options

        hide: ->
           @$el.modal 'hide'

        remove: ->
           @$el.remove()
           @close() if @close

        render: =>
            @$el.html this.template
            @$el.modal 'show'

            @