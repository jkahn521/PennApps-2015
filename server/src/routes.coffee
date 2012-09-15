app_name = 'Amplify Me!'

# home page
exports.index = (req, res) ->
    if !req.user?
        res.render 'home', {title: app_name}
    else
        res.render 'index', {title: app_name, user: req.user}

# amplify a tag
exports.amplify = (req, res) ->
    title = app_name
    if req.tag?
        title = 'Amplify #' + req.tag.name
    res.render 'amplify', {title: title, user: req.user, tag: req.tag} 