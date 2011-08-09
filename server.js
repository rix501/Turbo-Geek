/**
 * Module dependencies.
 */
//npm libraries
var express = require('express');

//My libraries
var rss = require('./rss');

var Models = require('./models');

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

var comics = new Models.Comics(    
    [{
        name: 'xkcd',
        url:'http://xkcd.com/rss.xml'
    },
    {
        name: 'smbc',
        url:'http://feeds.feedburner.com/smbc-comics/PvLb?fmt=xml'
    },
    {
        name: 'dinosaur',
        url:'http://www.rsspect.com/rss/qwantz.xml'
    },
    {
        name:'lady-sabre',
        url:'http://feeds.feedburner.com/ineffableaether?format=xml'    
    },
    {
        name:'penny-arcade',
        url:'http://feeds.penny-arcade.com/pa-mainsite?format=xml'    
    },
    {
        name:'letsbefriendsagain',
        url:'http://www.letsbefriendsagain.com/feed/'    
    }]
);

// Routes

app.get('/comics',function(req,res){
    var tempHTML = '<ul>'; 
    
    comics.forEach(function(comic){
        tempHTML += '<li><a href="/comic/' + comic.get('name') +'">'+ comic.get('name') + '</a></li>';
    });
    
    tempHTML += '</ul>';
    
    res.send(tempHTML);
});

app.get('/comic/:name',function(req,res){
    var comic = comics.find(function(comic){
        if(comic.get('name') === req.params.name){
            rss.parseURL(comic.get('url'), function(articles) {
                res.send(articles[0].description);
            });
        }
    });
    
    if(comic === null) {
        res.send('Not found');
    }
});

app.listen(process.env.C9_PORT || process.env.PORT || 8001);
console.log("Express server listening on port %d", app.address().port);