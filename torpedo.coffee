rss = require './rss'
_ = require('underscore')._
mysql = require 'mysql'
config = require './config'

updatePubDate = (comic, date, cb) ->
    connection = mysql.createConnection config.mysql

    connection.query 'CALL Update_Date(? , ?)', [comic.id, date.format('YYYY-MM-DD HH:MM:SS')], (err, rows, fields) =>
            if err then throw err

            cb?()

exports.fire = (cb) ->
    connection = mysql.createConnection config.mysql
    
    connection.query 'SELECT * FROM all_comics', (err, comics, fields) =>
        if err then throw err

        end = _.after comics.length, -> cb msg: 'OK'

        comics.forEach (comic) ->
            rss.parseComic comic, (parsedComic, articles) ->
                updatePubDate(parsedComic, articles[0].pubdate) if articles[0]?
                end()