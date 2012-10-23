_ = require('underscore')._
Backbone = require 'backbone'

class Item extends Backbone.Model

    initialize: () ->

    testForArticle: (comic) ->
        return false if not comic.get('includesArticles')

        rx = comic.get('comicRegex') ? /article|news|blog/gi
        
        rx.test(@get('category')) or 
            rx.test(@get('description')) or 
                rx.test(@get('summary')) or 
                    rx.test(@get('title'))
                    

module.exports = Item  