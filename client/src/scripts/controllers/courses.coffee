require('assets/lib/jquery.tmpl')
Spine = require 'assets/lib/spine'
List = require('assets/lib/list')
Course = require('scripts/models/course')
$ = Spine.$

class Courses extends Spine.Controller
  className: 'courses'


  elements:
    '.items': 'items'
    'form input': 'input'

  events:
    'submit form': 'submit'

  constructor: ->
    super

    @list = new List
      el: @items,
      template: (courses) -> $('#course_template').tmpl(courses),
      selectFirst: true

    @list.bind("change", @change)
    @render()

    Course.bind("refresh", @render)
    Course.bind("create", @createCourse)
    Course.fetch()


  render:  =>
    console.log 'running render'
    # @list.render(Course.all())
    @list.render(@userCourses())
  
  change: (item) =>
    @current = item
    # @render()

  createCourse: (item) =>
    @render()
    @change(item)

  submit: (e) =>
    try
      e.preventDefault()
      i = @input.val()
      course = Course.find(i)
      if course
        course.addFollower("olliejkahn@yahoo.com")
        @change course
        @input.val("")
      else
        alert 'course does not exist'
      @render()
    catch error
      alert 'that course does not exist'

      # course = Course.create(id: i)
    # if course
    #   course.save()
    #   @change course
    #   @input.val("")
    # else
    #   alert 'invalid course'

  userCourses: => 
    Course.select(
      (course) ->
        for c in course.followers
          if ("olliejkahn@yahoo.com" == c)
            return true
        false
    )

module.exports = Courses