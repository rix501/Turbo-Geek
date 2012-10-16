_ = require('underscore')._
Backbone = require 'backbone'

config = require '../config'
mysql = config.mysql

class Comic extends Backbone.Model

    initialize: () ->

    subscribe: ->

    unsubscribe: ->

    updatePubDate: (date, cb) -> 
        mysql.acquire (err, connection) =>
            connection.query 'CALL Update_Date(? , ?)', [@id, date.format('YYYY-MM-DD HH:MM:SS')], (err, rows, fields) =>
                    if err then throw err

                    mysql.release connection
                    cb?()

module.exports = Comic  