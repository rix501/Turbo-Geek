var sys = require('sys'), http = require('http');

var sax = require("sax"),
  strict = false, // set to false for html-mode
  parser = sax.parser(strict);



// variable for holding the callback function which is passed to the
// exported function. This callback is passed the articles array
var callback = function() {};

// The main "meat" of this module - parses an rss feed and triggers
// the callback when done.
// using node-xml: http://github.com/robrighter/node-xml

var rssParser = function(body) {
	
	var articles = Array();
	var current_element = false;
	var article_count = 0;
	var in_item = false;
	var current_chars = '';
	
	function addContent(chars) {
		if(in_item) {
			current_chars += chars;
		}
	};
	
	
	parser.onerror = function (e) {
	  	sys.puts('<ERROR>'+JSON.stringify(e)+"</ERROR>");
	};
	
	parser.ontext = function (t) {
	  // got some text.  t is the string of text.
		addContent(t);
	};
	
	parser.oncdata = function(){
		addContent(t);
	};
	
	parser.onopentag = function (node) {
	  // opened a tag.  node has "name" and "attributes"
	  	current_element = node.name.toLowerCase();
		if(current_element == 'item' || current_element == 'entry') {
			in_item = true;
			articles[article_count] = Array();
		}
	};
	
	parser.onclosetag = function(name){
		
		if(in_item) {
			switch(current_element) 
			{
				case 'description':
				case 'summary':
					articles[article_count][current_element] = current_chars.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
				break;
				case 'content':
				case 'encoded': // feedburner is <content:encoded>, node-xml reads as <encoded>
					current_element = 'content';
					articles[article_count][current_element] = current_chars.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
				break;
				case 'link':
				case 'title':
					articles[article_count][current_element] = current_chars.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
				break;
			}
			
			current_element = false;
			current_chars = '';
			if(name.toLowerCase() == 'item' || name.toString() == 'entry') {
				in_item = false;
				article_count ++;   
			}
		}
	};
	
	parser.onattribute = function (attr) {
	  // an attribute.  attr has "name" and "value"
	};
	parser.onend = function () {
	  // parser stream is done, and ready to have more stuff written to it.
		callback(articles);
	};
	
	//Start
	parser.write(body).close();
}







/**
 * parseURL()
 * Parses an RSS feed from a URL. 
 * @param url - URL of the RSS feed file
 * @param cb - callback function to be triggered at end of parsing
 *
 * @TODO - decent error checking
 */
exports.parseURL = function(url, cb) {
    callback = cb;

	var u = require('url'), http = require('http');
	var parts = u.parse(url);
	//sys.puts(JSON.stringify(parts));

	// set the default port to 80
	if(!parts.port) { parts.port = 80; }

	var redirection_level = 0;
    var client = http.createClient(parts.port, parts.hostname);
	var request = client.request('GET', parts.pathname, {'host': parts.hostname});
	request.addListener('response', function (response) {
	    //sys.puts('STATUS: ' + response.statusCode);
	    //sys.puts('HEADERS: ' + JSON.stringify(response.headers));

	    // check to see the type of status
	    switch(response.statusCode) {
		// check for ALL OK
	    case 200:
			var body = ''; 
			response.addListener('data', function (chunk) {
			    body += chunk;
			});
			response.addListener('end', function() {
			    rssParser(body);
			});
		break;
		// redirect status returned
	    case 301:
	    case 302:
			if(redirection_level > 10) {
			    sys.puts("too many redirects");
			}
			else {
			    sys.puts("redirect to "+response.headers.location);
			    get_rss(response.headers.location);
			}
		break;
	    default:
			/*
			response.setEncoding('utf8');
			response.addListener('data', function (chunk) {
			    //sys.puts('BODY: ' + chunk);
			});
			*/
		break;
	    }	  
	});
	request.end();	
};