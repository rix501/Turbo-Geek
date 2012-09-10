define([
    'mustache',
    'backbone'
],
function(Mustache) {
    return Backbone.View.extend({
        template: Mustache.compile($("#page-template").html()),
        el: 'body',
        events: {
        },
        initialize: function() {
            _.bindAll(this, 'render');
        },
        render: function() {
            this.$el.html(this.template());

            return this;
        }
    });
});