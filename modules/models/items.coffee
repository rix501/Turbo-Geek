sys = require 'util'
http = require 'http'
urlParser = require 'url'

_ = require('underscore')._
Backbone = require 'backbone'
moment = require 'moment'

sax = require 'sax'
strict = false # set to false for html-mode
saxParser = sax.parser strict

Item = require './item'
    
class Items extends Backbone.Collection
    initialize: (models, options) ->
        _.extend @, options

    model: Item

    parser: (body, cb) ->
        return unless @comic?

        item = null
        currentElement = false
        inItem = false
        currentChars = ''
        buildDate = null
       
        addContent = (chars) -> currentChars += chars

        saxParser.onerror = (e) -> sys.puts '<error>' + JSON.stringify(e) + '</error>'
            
        saxParser.ontext = (text) -> addContent text

        saxParser.oncdata = (text) -> addContent text
            
        saxParser.onopentag = (node) ->
            currentElement = node.name.toLowerCase()
            if currentElement is 'item' or currentElement is 'entry'
                inItem = true
                item = new Item
                    
        saxParser.onclosetag = (name) =>
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
                    
                    if not item.get('pubdate') and @buildDate? 
                        item.set 'pubdate', @buildDate

                    @add item

            else 
                switch currentElement
                    when 'lastbuilddate' 
                        @buildDate = moment currentChars.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

            currentElement = false
            currentChars = ''

        saxParser.onattribute = (attr) -> # an attribute.  attr has "name" and "value"
        
        saxParser.onend = =>  
            console.log @comic.toJSON()
            @comic.trigger 'update:date'
            cb() if cb

        #Start
        saxParser.write(body).close()

    fetch: (options) ->
        return unless @comic?

        options = options or {}

        url = options.url or @comic.get 'feed'

        body = ''

        parts = urlParser.parse @comic.get 'feed'

        # set the default port to 80
        if parts.port? then parts.port = 80
        
        redirectionLevel = 0
        request = http.request
            method: 'GET'
            port: parts.port
            host: parts.hostname
            path: parts.pathname

        request.addListener 'response', (response) =>        
            switch response.statusCode
                when 200
                    body = ''
                    response.addListener 'data', (chunk) -> body += chunk
                    response.addListener 'end', => @parser body, options.success
                # redirect status returned
                when 301, 302
                    if redirectionLevel > 10 then sys.puts 'too many redirects'
                    else 
                        sys.puts 'redirect to ' + response.headers.location
                        @fetch url: response.headers.location

        request.end()



module.exports = Items