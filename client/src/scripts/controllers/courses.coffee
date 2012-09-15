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
    # Course.refresh({id: "cis100", status: "open"})


  render:  =>
    console.log 'running render'
    @list.render(Course.all())
  
  change: (item) =>
    @current = item
    # @render()

  createCourse: (item) =>
    @render()
    @change(item)

  submit: (e) =>
    e.preventDefault()
    i = @input.val()
    course = Course.create(id: i)
    if course
      course.save()
      @change course
      @input.val("")
    else
      alert 'invalid course'

module.exports = Courses