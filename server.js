/**
 * Module dependencies.
 */
//npm libraries
var express = require('express');
var rss = require("./node-rss");

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


var feed_url = 'http://xkcd.com/rss.xml';

//var response = rss.parseURL(feed_url, function(articles) {
//    console.log(articles.length);
    //for(i=0; i<articles.length; i++) {
    //console.log("Article: "+i+", "+
		 //articles[i].title+"\n"+
		 //articles[i].link+"\n"+
		 //articles[i].description+"\n"+
		 //articles[i].content
		//);
 //   }
//});



// Routes

app.get('/photo',function(req,res){
    rss.parseURL(feed_url, function(articles) {
        res.send(articles[0].description);
    });
});



app.listen(process.env.C9_PORT || process.env.PORT || 8001);
console.log("Express server listening on port %d", app.address().port);