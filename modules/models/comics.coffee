rss = require '../libs/rss'
_ = require('underscore')._
Backbone = require 'backbone'

config = require '../config'
mysql = config.mysql

Comic = require './comic'
    

class Comics extends Backbone.Collection

    initialize: () ->

    model: Comic

    getAllComics: (options) ->
        options = options or {}

        mysql.acquire (err, connection) =>
            connection.query 'SELECT * FROM all_comics', (err, rows, fields) =>
                if err then throw err
                
                mysql.release connection

                @reset @parse(rows), options
                options.success @ if options.success   

    getAllComicsToUpdate: (options) ->
        options = options or {}

        mysql.acquire (err, connection) =>
            connection.query 'SELECT * FROM all_comics_to_update', (err, rows, fields) =>
                if err then throw err
                
                mysql.release connection

                console.log rows

                @reset @parse(rows), options
                options.success @ if options.success   

    getNewComics: (options) ->
        options = options or {}

        mysql.acquire (err, connection) =>
            connection.query 'SELECT * FROM new_comics', (err, rows, fields) =>
                if err then throw err
                
                mysql.release connection

                @reset @parse(rows), options
                options.success @ if options.success   

    updateComics: (cb)-> 
        @getAllComicsToUpdate
            success: =>
                end = _.after @length, -> cb msg: 'OK'

                @each (comic) ->
                    rss.parseComic comic, (parsedComic, articles) ->
                        console.log articles
                        parsedComic.updatePubDate(articles[0].pubdate) if articles[0]?
                        end()

module.exports = Comics