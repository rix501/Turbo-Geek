define([
    'backbone'
],
function() {
    return Backbone.Model.extend({
        initialize: function() {
            
        },
        subscribe: function(){
            var req = $.ajax({
                url: '/subscribe/' + this.id,
                type: 'POST'
            });

            req.then(_.bind(function(){
                this.set({
                    IsMine: true
                });
            },this));
        },
        unsubscribe: function(){
            var req = $.ajax({
                url: '/subscribe/' + this.id,
                type: 'DELETE'
            });

            req.then(_.bind(function(){
                this.set({
                    IsMine: false
                });
            },this));
        }
    });
});