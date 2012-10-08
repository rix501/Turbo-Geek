if not process.env.NODE_ENV or process.env.NODE_ENV is 'development' 
    mysql =
        host     : 'localhost'
        user     : 'root'
        password : ''
        database : 'Turbo'

else if process.env.NODE_ENV is 'production'
    mysql = {}

module.exports = 
    mysql: mysql