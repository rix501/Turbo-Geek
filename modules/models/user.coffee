_ = require('underscore')._
Backbone = require 'backbone'

config = require '../config'
mysql = config.mysql

class User extends Backbone.Model

    initialize: () ->

    getUser: (cb) -> 
        username = @get 'username'
        mysql.acquire (err, connection) =>
            connection.query 'CALL Get_User(?)', [username], (err, rows, fields) =>
                if err then throw err
                users = rows[0]
                @set users[0]
                cb @ if cb and _.isFunction cb
                mysql.release connection

    createUser: (cb) ->
        username = @get 'username'
        password = @get 'password'
        mysql.acquire (err, connection) =>
            connection.query 'CALL CreateUser(?, ?)', [username, password], (err, result, fields) =>
                if err then throw err

                if _.isArray(result) and result[0][0].error
                    status =
                        created: no
                        message: result[0][0].error
                else
                    @set id: result.insertId
                    status =
                        created: yes
                        message: 'ok'

                cb status, @ if cb and _.isFunction cb
                mysql.release connection

    markComicRead: (comicId, cb) -> 
        return if not @id? and not comicId?
        mysql.acquire (err, connection) =>
            connection.query 'CALL Mark_Subscription_Read(? , ?)', [@id, comicId], (err, result, fields) =>
                if err then throw err

                if _.isArray(result) and result[0][0].error
                   status =
                       created: no
                       message: result[0][0].error
                else
                   status =
                       created: yes
                       message: 'ok'

                cb status, @ if cb and _.isFunction cb
                mysql.release connection

    subscribe: (comicId, cb) -> 
        return if not @id? and not comicId?
        mysql.acquire (err, connection) =>
            connection.query 'CALL Subscribe(? , ?)', [@id, comicId], (err, result, fields) =>
                if err then throw err

                if _.isArray(result) and result[0][0].error
                   status =
                       created: no
                       message: result[0][0].error
                else
                   status =
                       created: yes
                       message: 'ok'

                cb status, @ if cb and _.isFunction cb
                mysql.release connection

    unsubscribe: (comicId, cb) ->
        return if not @id? and not comicId?
        mysql.acquire (err, connection) =>
            connection.query 'CALL Unsubscribe(? , ?)', [@id, comicId], (err, result, fields) =>
                if err then throw err

                if _.isArray(result) and result[0][0].error
                   status =
                       created: no
                       message: result[0][0].error
                else
                   status =
                       created: yes
                       message: 'ok'

                   cb status, @ if cb and _.isFunction cb
                   mysql.release connection

module.exports = User  