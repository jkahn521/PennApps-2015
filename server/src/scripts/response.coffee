exports.resp =
    UNAUTHORIZED: 401
    NOT_FOUND: 204
    INTERNAL: 500
    BAD: 400
    FORBIDDEN: 403
    CONFLICT: 409
    CREATED: 201
    OK: 200

    success: (res, msg) ->
        res.status @OK
        res.send {status: @OK, success: msg}

    error: (res, code, msg) ->
        res.status code
        res.send {status: code, error: msg}

    user: (res, user, isPublic = false) ->
        if user['type'] isnt 'user'
            resp.error res, resp.BAD, 'id does not correspond to a user'
            return
    
        user = clean_user user, isPublic
        
        res.status @OK
        res.send user


    users: (res, body) ->
        users = []
        for r in body
            user = clean_user r.value, true
            users.push user
        
        res.status @OK
        res.send users

    tag: (res, tag, isNew = false) ->
        if tag.type isnt 'tag'
            @error res, @INTERNAL, 'is not a tag'
            return
        tag = clean_tag tag

        if isNew
            res.status @CREATED
        else
            res.status @OK
        res.send tag
