define([
    'models/comic',
    'backbone'
],
function(Comic) {
    return Backbone.Collection.extend({
        initialize: function() {
            
        },
        model: Comic,
        url: '/comics'
    });
});