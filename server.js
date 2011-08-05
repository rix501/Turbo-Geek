/**
 * Module dependencies.
 */
//npm libraries
var express = require('express');

var app = express.createServer();


// Express Configuration
app.configure(function(){
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use(app.router);
	app.use(express.static(__dirname + '/public'));
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  
});

// Routes


app.listen(process.env.C9_PORT || process.env.PORT || 8001);
console.log("Express server listening on port %d", app.address().port);