express    = require 'express'
routes     = require './routes'
api        = require './scripts/api'
email = require './scripts/email'

# Added by Josh --------------------------------------------------------
require 'coffee-script'
stitch = require 'stitch'

src_path = __dirname + "/../../client/src/"

stitch_package = stitch.createPackage(
    # Specify the paths you want Stich to automatically bundle up
    paths: [ src_path ]

    # Specify base libraries
    dependencies: []
)
# Added by Josh --------------------------------------------------------

app = module.exports = express.createServer()

sessions = {} # in memory/temporary store. use connect-couchdb later for persistent session store


# Configuration

app.configure ->
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.favicon(__dirname + '/../../client/gen/assets/images/favicon.ico')
    app.use(express.static(__dirname + '/../../client/gen'))
    app.use(app.router)
    #added by Josh
    app.get("/application.js", stitch_package.createServer())


app.configure 'development', ->
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', ->
    app.use(express.errorHandler())

# Routes
app.get '/', routes.index
app.get '/courses', api.all_courses_csv
app.post '/follow/:course/:id', api.follow_course
app.get '/email', api.send_email

# Heroku ports or 3000
port = process.env.PORT || 3000
app.listen port, ->
    console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env

# # Initialize sockets
# sockets.init app

email.check_courses()


