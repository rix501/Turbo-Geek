poolModule = require 'generic-pool'
mysql = require 'mysql'

if not process.env.NODE_ENV or process.env.NODE_ENV is 'development' 
    mysqlConf =
        host     : 'localhost'
        user     : 'root'
        password : ''
        database : 'Turbo'

else if process.env.NODE_ENV is 'production'
    mysqlConf = process.env.DATABASE_URL

pool = poolModule.Pool
    name     : 'mysql'
    create   : (callback) ->
        connection = mysql.createConnection mysqlConf
        connection.connect()
        connection.on 'error', (err) ->
            if not err.fatal then return
            if err.code isnt 'PROTOCOL_CONNECTION_LOST' then throw err

        callback(null, connection)
    destroy  : (client) -> client.end() 
    max      : 10
    idleTimeoutMillis : 30000

module.exports = 
    mysql: pool