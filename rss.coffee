sys = require 'util'
http = require 'http'
urlParser = require 'url'

moment = require 'moment'

sax = require 'sax'
strict = false # set to false for html-mode
parser = sax.parser strict

# Holds the callback which is passed to the exported function. 
callback = ->
comicObj = null

rssParser = (body, comic = null) ->
    articles = []
    currentElement = false
    articleCount = 0
    inItem = false
    currentChars = ''
    buildDate = null
   
    addContent = (chars) -> currentChars += chars

    parser.onerror = (e) -> sys.puts '<error>' + JSON.stringify(e) + '</error>'
        
    parser.ontext = (text) -> addContent text

    parser.oncdata = (text) -> addContent text
        
    parser.onopentag = (node) ->
        currentElement = node.name.toLowerCase()
        if currentElement is 'item' or currentElement is 'entry'
            inItem = true
            articles[articleCount] = []
                
    parser.onclosetag = (name) ->
        if inItem
            switch currentElement
                when 'description', 'summary', 'link', 'title'
                    articles[articleCount][currentElement] = currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
                
                when 'content','encoded'
                    # feedburner is <content:encoded>, node-xml reads as <encoded>
                    currentElement = 'content'
                    articles[articleCount][currentElement] = currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

                when 'pubdate'
                    articles[articleCount][currentElement] = moment currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
                        
            if name.toLowerCase() is 'item' or name.toString() is 'entry'
                inItem = false
                if not articles[articleCount]['pubdate'] and buildDate? then articles[articleCount]['pubdate'] = buildDate
                articleCount++
        else 
            switch currentElement
                when 'lastbuilddate' 
                    buildDate = moment currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

        currentElement = false
        currentChars = ''


    parser.onattribute = (attr) -> # an attribute.  attr has "name" and "value"
    
    parser.onend = -> if comic? then callback(comic, articles) else callback(articles)

    #Start
    parser.write(body).close()

getRss = (url, comic = null) ->
    parts = urlParser.parse url

    # set the default port to 80
    if parts.port? then parts.port = 80
    
    redirectionLevel = 0
    request = http.request
        method: 'GET'
        port: parts.port
        host: parts.hostname
        path: parts.pathname

    request.addListener 'response', (response) ->        
        switch response.statusCode
            when 200
                body = ''
                response.addListener 'data', (chunk) -> body += chunk
                response.addListener 'end', -> rssParser body, comic
            # redirect status returned
            when 301, 302
                if redirectionLevel > 10 then sys.puts 'too many redirects'
                else 
                    sys.puts 'redirect to ' + response.headers.location
                    getRss response.headers.location

    request.end()

exports.parseURL = (url, cb) ->
    callback = cb
    getRss url

exports.parseComic = (comic, cb) ->
    callback = cb
    getRss comic.feed, comic