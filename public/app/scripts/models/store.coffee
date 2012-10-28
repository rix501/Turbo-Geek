define (require) ->

    class Store

        set: (key, val) ->
            res = if val then JSON.stringify(val) else null
            if res
                localStorage.setItem key, res
            else
                @remove key

        get: (key) ->
            res = localStorage.getItem key
            if res then JSON.parse(res) else null

        remove: (key) ->
            localStorage.removeItem key

        clear: ->
            localStorage.clear()

    new Store