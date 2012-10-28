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
            if @userId?
                connection.query 'CALL GetAllComics(?)', [@userId], (err, rows, fields) =>
                    if err then throw err
                    
                    mysql.release connection

                    realRows = rows[0]

                    @reset @parse(realRows), options
                    options.success @ if options.success  
            else
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

                @reset @parse(rows), options
                options.success @ if options.success   

    getNewComics: (options) ->
        options = options or {}
        mysql.acquire (err, connection) =>
            if @userId?
                connection.query 'CALL GetNewComics(?)', [@userId], (err, rows, fields) =>
                    if err then throw err
                    
                    mysql.release connection

                    realRows = rows[0]

                    @reset @parse(realRows), options
                    options.success @ if options.success  
            else
                connection.query 'SELECT * FROM new_comics', (err, rows, fields) =>
                    if err then throw err
                    
                    mysql.release connection

                    @reset @parse(rows), options
                    options.success @ if options.success   

    getUserComics: (options) ->
        options = options or {}

        mysql.acquire (err, connection) =>
            connection.query 'CALL GetUserComics(?)', [@userId], (err, rows, fields) =>
                if err then throw err
                
                mysql.release connection

                realRows = rows[0]

                @reset @parse(realRows), options
                options.success @ if options.success  

    updateComics: (cb)-> 
        @getAllComicsToUpdate
            success: =>
                end = _.after @length, -> cb msg: 'OK'

                @on 'change:date', end

                @each (comic) -> comic.getItems()


module.exports = Comics