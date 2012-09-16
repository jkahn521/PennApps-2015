app_name = 'Course Alert'

# home page
exports.index = (req, res) ->
  res.render 'index', {title: app_name, user: req.user}