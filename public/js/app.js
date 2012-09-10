define([
    'views/Page',
    'views/Comics',
    'jquery',
    'underscore',
    'backbone',
    'bootstrap'
],
function(PageView, ComicsView) {
    return Backbone.Router.extend({
        routes: {
            '' : 'index'
        },
        initialize: function() {
            this.pageView = new PageView();
            this.pageView.render();
        },
        updateContent: function(){
            this.pageView.$('.content').html(this.currentView.render().el);
        },
        index: function() {
            this.currentView = new ComicsView();
            this.updateContent();
        }
    });
});