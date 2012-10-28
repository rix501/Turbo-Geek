define (require) ->
    Mustache = require 'mustache'
    Backbone = require 'backbone'
    Bootstrap = require 'bootstrap'

    Viewer = require 'models/user'

    Modal = require 'views/modal'

    MODAL_TEMPLATE = require 'text!tmpl/signup-modal.mustache'

    class SignupModal extends Modal
        template: Mustache.compile MODAL_TEMPLATE

        events: _.extend
            'click .submit': 'render'
        , Modal::events

        render: =>
            @$el.html this.template

            @$el.modal 'show'

            @