config     = require '../config'
utils      = require '../utils/amplifyme'
{resp}     = require './response'



create_user = (user, callback) ->
    if user? && user.t_id? && user.t_token? && user.t_secret? && user.screen_name?
        user.type = 'user'  # ensures type is user 
        user.tags = []
        user.subscribed = []
        user.created_at = new Date().getTime()
        db.insert user, (err, header, body) ->
            if !err
                console.log 'USER CREATED'
                console.log header
                if header.ok is true
                    user.id = header.id
                    user.rev = header.rev
                    sockets.new_user user
                    return callback null, user
                else
                    return callback 'something went wrong', null
            else
                return callback err, null
    else
        return callback 'invalid parameters for user', null


#-------------------------ME-------------------------#
# (Authentication required)

# GET /me
# returns authenticated Uesr with twitter id
exports.get_me = (req, res) ->
    # check if id exists
    id = req.user.t_id
    screen_name = req.user.screen_name
    db.view 'users', 'twitter', {key: id}, (err, body) ->
        if !err
            console.log body
            if body.rows.length is 1
                user = body.rows[0].value
                user.screen_name = screen_name
                resp.user res, user
            else
                resp.error res, resp.NOT_FOUND, 'user not found'
        else
            resp.error res, resp.INTERNAL, err



exports.get_tag_by_hash = (hash, callback) ->
    db.view 'tags', 'byHash', {key: hash}, (err, body) ->
        if !err
            if body.rows.length > 0
                tag = body.rows[0].value
                tag.id = tag._id
                delete tag._id
                delete tag._rev
                callback tag
            else
                callback null
        else
            callback null


    
#-----------------------PUBLIC-----------------------#

# GET /users
# retrieves all users
exports.get_users = (req, res) ->
    db.view 'users', 'list', (err, body) ->
        if !err
            console.log 'GET USERS'
            resp.users res, body.rows
        else
            resp.error res, resp.INTERNAL err

# GET /users/:id
# retrieves a User Object
exports.get_user = (req, res) ->
    id = req.params.id
    db.get id, {}, (err, body) ->
        if !err
            console.log 'GET USER'
            resp.user res, body, true
        else
            resp.error res, resp.INTERNAL, err              

