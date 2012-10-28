define (require) ->
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Bootstrap = require 'bootstrap'

    MODAL_TEMPLATE = require 'text!tmpl/modal.mustache'

    class Modal extends Backbone.View

        template: MODAL_TEMPLATE

        tagName: 'div'
        className: 'modal fade'

        events: 
            'hidden' : 'remove'

        hide: ->
           @$el.modal 'hide'

        remove: ->
           @$el.remove()

        render: =>
            @$el.html this.template
            @$el.modal 'show'

            @