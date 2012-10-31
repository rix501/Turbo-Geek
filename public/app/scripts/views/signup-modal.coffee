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
            'submit form': 'signup'
        , Modal::events

        signup: (e) ->
            e.stopPropagation()
            e.preventDefault()

            Viewer.save
                username: @$('form input[name="username"]').val()
                password: @$('form input[name="password"]').val()
            , 
                wait: true
                success: (model) =>
                    Viewer.trigger 'create'
                    @hide()
                error: (model, resp) =>

        render: =>
            @$el.html this.template

            @$el.modal 'show'

            @