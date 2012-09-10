define([
    'models/Comics',
    'views/Comic',
    'mustache',
    'backbone'
],
function(Comics, ComicView, Mustache) {
    return Backbone.View.extend({
        template: Mustache.compile($("#comics-template").html()),
        events: {
        },
        initialize: function() {
            _.bindAll(this, 'render', 'add', 'addAll');

            this.collection = new Comics();
            this.collection.bind('reset', this.addAll, this);
            this.collection.bind('change:IsMine', function(model, IsMine){
                if(IsMine){
                    this.add(model, 'my-comics');
                } else {
                    this.$('.my-comics .comic-' + model.id).remove();
                }
            }, this);

            this.collection.fetch();
        },
        add: function(model, group){
            var comicView = new ComicView({
                model: model
            });

            var el = comicView.render().el;

            this.$('ul.' + group).append(el);
        },
        addAll: function(collection){
            var myComics = collection.filter(function(model){
                return model.get('IsMine');
            });

            _.each(myComics, _.bind(function(model){
                this.add(model, 'my-comics');
            }, this));

            collection.each(_.bind(function(model){
                this.add(model, 'comics');
            }, this));
        },
        render: function() {
            this.$el.html(this.template());

            return this;
        }
    });
});