Spine = require 'assets/lib/spine'
require 'assets/lib/ajax'

class Course extends Spine.Model
  @configure 'Course', 'status', 'followers'
  @extend Spine.Model.Ajax
  # @url: "/api/"

  # validate: ->
  #   ''

  addFollower: (user) -> 
    console.log 'before ' + @followers
    for c in @followers
      if (user == c)
        alert "you're already enrolled in that course"
        return @followers
    f = @followers
    f.push(user)
    @followers = f
    console.log 'after ' + @followers


module.exports = Course