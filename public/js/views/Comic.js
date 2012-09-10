define([
    'mustache',
    'backbone'
],
function(Mustache) {
    return Backbone.View.extend({
        template: Mustache.compile($("#comic-template").html()),
        events: {
            'click a.subscribe' : 'subscribe',
            'click a.unsubscribe' : 'unsubscribe'
        },
        tagName: 'li',
        className: 'comic',
        initialize: function() {
            _.bindAll(this, 'render', 'subscribe', 'unsubscribe');

            this.model.bind('change:IsMine', this.render, this);

        },
        subscribe: function(event){
            event.preventDefault();

            this.model.subscribe();

            return false;
        },
        unsubscribe: function(event){
            event.preventDefault();

            this.model.unsubscribe();

            return false;
        },
        render: function() {
            this.$el.addClass('comic-' + this.model.id);

            this.$el.html(this.template(this.model.toJSON()));

            return this;
        }
    });
});