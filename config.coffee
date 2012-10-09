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

# Create a MySQL connection pool with
# a max of 10 connections, a min of 2, and a 30 second max idle time
pool = poolModule.Pool
    name     : 'mysql'
    create   : (callback) ->
        connection = mysql.createConnection mysqlConf
        connection.connect()
        callback(null, connection)
    destroy  : (client) -> client.end() 
    max      : 10
    idleTimeoutMillis : 30000,

module.exports = 
    mysql: pool