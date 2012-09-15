Spine = require 'assets/lib/spine'
require 'assets/lib/ajax'

class Course extends Spine.Model
  @configure 'Course', 'status'
  @extend Spine.Model.Ajax
  # @url: "/api/"

module.exports = Course