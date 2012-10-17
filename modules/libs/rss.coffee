sys = require 'util'
http = require 'http'
urlParser = require 'url'

moment = require 'moment'

sax = require 'sax'
strict = false # set to false for html-mode
parser = sax.parser strict

Item = require '../models/item'
Items = require '../models/items'

# Holds the callback which is passed to the exported function. 
callback = ->
comicObj = null

rssParser = (body, comic = null) ->
    items = new Items
    item  = null
    currentElement = false
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
            item = new Item
                
    parser.onclosetag = (name) ->
        if inItem
            switch currentElement
                when 'description', 'summary', 'link', 'title', 'guid'
                    item.set currentElement, currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
                
                when 'content','encoded'
                    currentElement = 'content'
                    item.set currentElement, currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

                when 'pubdate'
                    item.set currentElement, moment.utc currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')
                        
            if name.toLowerCase() is 'item' or name.toString() is 'entry'
                inItem = false
                
                if not item.get('pubdate') and buildDate? 
                    item.set 'pubdate', buildDate

                items.add item

        else 
            switch currentElement
                when 'lastbuilddate' 
                    items.buildDate = moment currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

        currentElement = false
        currentChars = ''


    parser.onattribute = (attr) -> # an attribute.  attr has "name" and "value"
    
    parser.onend = -> 
        if comic? 
            comic.set 'items', items
            comic.trigger 'update:date'
        else 
            callback(items)

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

exports.parseComic = (comic) ->
    getRss comic.get('feed'), comic