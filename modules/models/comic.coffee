_ = require('underscore')._
Backbone = require 'backbone'

config = require '../config'
mysql = config.mysql

Items = require './items'

class Comic extends Backbone.Model

    initialize: () ->
        @on 'update:date', @updatePubDate
        @set 'items', new Items([], comic: @)

    subscribe: ->

    unsubscribe: ->

    getItems: (cb) ->
        items = @get('items')

        items.fetch
            success: cb

    updatePubDate: (cb) -> 
        if @get('items').at(0)?
            date = @get('items').at(0).get 'pubdate' 
            guid = @get('items').at(0).get('guid') ? @get('items').at(0).get('link')
            @set 'date', date

            return if @get('lastGuid')? and @get('lastGuid') is guid

            mysql.acquire (err, connection) =>
                connection.query 'CALL Update_Comic(?, ?, ?)', [@id, date.format('YYYY-MM-DD HH:MM:SS', 'utc'), guid], (err, rows, fields) =>
                        if err then throw err
                        mysql.release connection
        else
            @set 'date', null

module.exports = Comic  