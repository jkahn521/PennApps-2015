Spine = require 'assets/lib/spine'
Tags = require 'scripts/controllers/tags'
Subscriptions = require 'scripts/controllers/subscriptions'
Details = require 'scripts/controllers/details'
Tag = require('scripts/models/tag')
Route = require 'assets/lib/route'

$ = Spine.$

class TagsApp extends Spine.Controller
  constructor: ->
    super
    @tags = new Tags({el: $("#courses")})
    @details = new Details({el: $("#all_coureses")})
    # @subscriptions = new Subscriptions({el: $("#subscriptions")})

    @append @tags, @details

    @routes
      '/tags/:id': (params) ->
        @tags.change(Tag.find(params.id))
        @details.change(params)
      '/tags_subscription/:id': (params) ->
        console.log 'click subscriptions'
        @details.change_subscription(params)

    Spine.Route.setup()

    

module.exports = TagsApp