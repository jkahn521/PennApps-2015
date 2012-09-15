Spine = require 'assets/lib/spine'
Tags = require 'scripts/controllers/tags'
# Subscriptions = require 'scripts/controllers/subscriptions'
# Details = require 'scripts/controllers/details'
Course = require('scripts/models/tag')
# Route = require 'assets/lib/route'

$ = Spine.$

class SpineApp extends Spine.Controller
  constructor: ->
    super
    @courses = new Courses({el: $("#courses")})
    @all_courses = new AllCourses({el: $("#all_courses")})
    # @subscriptions = new Subscriptions({el: $("#subscriptions")})

    @append @courses, @all_courses

    

module.exports = SpineApp