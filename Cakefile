{exec, spawn} = require 'child_process'
path = require 'path'

option '-w', '--watch', 'watch changes from project and build'
option '-b', '--build', 'build the project before run'
option '-d', '--data', 'for data database migration'

dir = 
    gen: 
        client: 'client/gen'
        server: 'server/gen'
    assets:
        src: 'client/src/assets/'
        gen: 'client/gen/assets/'
    scripts:
        src: 'client/src/scripts/'
        gen: 'client/gen/scripts/'
    stylesheets:
        name: 'stylesheets'
        src: 'client/src/assets/stylesheets'
        gen: 'client/gen/assets/stylesheets'
    lib:
        src: 'client/src/assets/lib/'
        gen: 'client/gen/assets/lib/'
    server_scripts:
        src: 'server/src/scripts/'
        gen: 'server/gen/scripts/'
    views:
        src: 'server/src/views/'
        gen: 'server/gen/views/'
    server:
        src: 'server/src/'
        gen: 'server/gen/'
    migration: 'server/gen/scripts/migration.js'
    data_migration: 'server/gen/scripts/data/migration.js'

colors =
    black     : '\x1B[0;30m'
    red       : '\x1B[0;31m'
    green     : '\x1B[0;32m'
    yellow    : '\x1B[0;33m'
    blue      : '\x1B[0;34m'
    magenta   : '\x1B[0;35m'
    cyan      : '\x1B[0;36m'
    grey      : '\x1B[0;90m'
    bold: 
      bold        : '\x1B[0;1m'
      black       : '\x1B[0;1;30m'
      red         : '\x1B[0;1;31m'
      green       : '\x1B[0;1;32m'
      yellow      : '\x1B[0;1;33m'
      blue        : '\x1B[0;1;34m'
      magenta     : '\x1B[0;1;35m'
      cyan        : '\x1B[0;1;36m'
      white       : '\x1B[0;1;37m'
    reset       : '\x1B[0m'

watch = false

task 'build', 'build project from source', (options) ->
    if options.watch?
        watch = true
    else
        watch = false
    build () ->
        console.log 'done.'

task 'run', 'run the app', (options) ->
    if options.watch?
        watch = true
    else
        watch = false

    if options.build?
        build () ->
            run()
    else
        run()    

data = false
task 'migrate', 'update database', (options) ->
    if options.data?
        data = true
    else
        data = false
    if options.build?
        build () ->
            migrate()
    else
        migrate()

migrate = () ->
    if data
        process = spawn 'node', [dir.data_migration]
    else
        process = spawn 'node', [dir.migration]
    process.stdout.setEncoding('utf8')
    process.stdout.on 'data', (data) ->
        console.log data
    process.stderr.setEncoding('utf8')
    process.stderr.on 'data', (data) ->
        console.log data

#TODO
# build folder structure

module =
    coffee: './node_modules/.bin/coffee -co'
    stylus: './node_modules/.bin/stylus -o'
    nib: './node_modules/nib/lib/nib.js'

log = 
    reset: colors.reset
    time: colors.grey
    COMPILE:
        name: 'COMPILE'
        color: colors.bold.yellow
    COPY:
        name: 'COPY'
        color: colors.bold.magenta
    CREATE:
        name: 'CREATE'
        color: colors.bold.cyan
    DELETE:
        name: 'DELETE'
        color: colors.bold.red

    print: (action, directory) ->
        out = "  " + "#{log.time}" + "#{(new Date).toLocaleTimeString()}" + " - " + "#{action.color}#{action.name}#{log.reset}" + " #{directory}"
        console.log out

onError = (err)->
  if err
    process.stdout.write "#{colors.red}#{err.stack}#{colors.reset}\n"
    process.exit -1

run = () ->
    process = spawn 'node', ['server/gen/app.js']
    process.stdout.setEncoding('utf8')
    process.stdout.on 'data', (data) ->
        console.log data
    process.stderr.setEncoding('utf8')
    process.stderr.on 'data', (data) ->
        console.log data

clean = (callback) ->
    # cleaning server gen folder
    exec "rm -rf '#{dir.gen.server}'", (err, stdout, stderr) ->
        onError err
        log.print log.DELETE, dir.gen.server

        # cleaning client gen folder
        exec "rm -rf '#{dir.gen.client}'", (err, stdout, stderr) ->
            onError err
            log.print log.DELETE, dir.gen.client
            callback()


build = (callback) ->

    clean () ->

        # generate server javascript
        exec "#{module.coffee} '#{path.dirname dir.server_scripts.gen}' '#{path.dirname dir.server_scripts.src}'", (err, stdout, stderr) ->
            onError err 
            log.print log.COMPILE, dir.server.gen
        if watch
            server_watch = spawn 'coffee', ['-cw', '-o', dir.server_scripts.gen, dir.server_scripts.src]
            server_watch.stdout.on 'data', (data) -> console.log data.toString().trim()

        # create views directory
        exec "mkdir -p '#{dir.views.gen}'", (err) ->
            onError err 
            exec "rsync -av '#{dir.views.src}' '#{dir.views.gen}'", (err) ->
                onError err
                log.print log.CREATE, dir.views.gen

        # create assets directory
        exec "mkdir -p '#{dir.assets.gen}'", (err) ->
            onError err
            log.print log.CREATE, dir.assets.gen
            # copy assets (excluding stylesheets)
            exec "rsync -av --exclude='#{dir.stylesheets.name}' '#{dir.assets.src}' '#{dir.assets.gen}'", (err) ->
                onError err
                log.print log.CREATE, dir.assets.gen

            # create scripts directory
            exec "cp -r '#{dir.lib.src}' '#{dir.lib.gen}'", (err) ->
                onError err
                log.print log.COPY, dir.lib.gen

            # compiles stylus
            exec "mkdir -p '#{dir.stylesheets.gen}'", (err) ->
                onError err
                exec "#{module.stylus} '#{dir.stylesheets.gen}' '#{dir.stylesheets.src}' --use #{module.nib}", (err, stdout, stderr) ->
                    onError err
                    log.print log.COMPILE, dir.stylesheets.gen
                    console.log stdout + stderr

                    # if watch
                    #     stylus_watch = spawn './node_modules/.bin/stylus', [dir.stylesheets.src, '-w', '-o', dir.stylesheets.gen]
                    #     stylus_watch.stdout.on 'data', (data) -> console.log data.toString().trim()

                    # temporary
                    callback()

        # generate client javascript
        exec "#{module.coffee} -co '#{path.dirname dir.scripts.gen}' '#{path.dirname dir.scripts.src}'", (err, stdout, stderr) ->
            onError err
            log.print log.COMPILE, dir.scripts.gen
        if watch
            client_watch = spawn 'coffee', ['-cw', '-o', dir.scripts.gen, dir.scripts.src]
            client_watch.stdout.on 'data', (data) -> console.log data.toString().trim()


