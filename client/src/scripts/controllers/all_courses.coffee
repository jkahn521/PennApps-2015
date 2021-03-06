require('assets/lib/jquery.tmpl')
Spine = require 'assets/lib/spine'
List = require('assets/lib/list')
Course = require('scripts/models/course')
$ = Spine.$

class AllCourses extends Spine.Controller
  className: 'allcourses'


  elements:
    '.items': 'items'
    'form input': 'input'

  events:
    'submit form': 'submit'

  constructor: ->
    super

    @list = new List
      el: @items,
      template: (courses) -> $('#all_course_template').tmpl(courses),
      selectFirst: true

    @list.bind("change", @change)
    @render()

    Course.bind("refresh", @render)
    Course.bind("create", @createCourse)
    # Course.fetch()
    Course.refresh({id: "cis120", status: "open"})


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
    course = Course.create(name: i)
    if course
      course.save()
      @change course
      @input.val("")
    else
      alert 'invalid course'

module.exports = AllCourses