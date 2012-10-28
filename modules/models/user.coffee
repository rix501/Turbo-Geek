_ = require('underscore')._
Backbone = require 'backbone'

config = require '../config'
mysql = config.mysql

class User extends Backbone.Model

    initialize: () ->

    getUser: (username, cb) -> 
        username = username ? @get 'username'
        mysql.acquire (err, connection) =>
            connection.query 'CALL Get_User(?)', [username], (err, rows, fields) =>
                if err then throw err
                users = rows[0]
                @set users[0]
                cb @
                mysql.release connection

module.exports = User  