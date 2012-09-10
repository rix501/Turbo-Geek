var rss = require('./rss');
var _ = require('underscore')._;

var comics = [
    {
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
    }
];

exports.fire = function(cb){
    var wut = '';

    var end = _.after(comics.length, function(){
        cb(wut);
    });

    comics.forEach(function(comic){
        rss.parseURL(comic.url, function(articles) {
            wut += articles[0].description;
            end();
        }.bind(this));
    });
};