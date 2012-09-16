Spine = require 'assets/lib/spine'
require 'assets/lib/ajax'
$ = Spine.$

class Course extends Spine.Model
  @configure 'Course', 'status', 'followers'
  @extend Spine.Model.Ajax
  # @url: "/api/"

  # validate: ->
  #   ''

  addFollower: (user) -> 
    for c in @followers
      if (user == c)
        alert "Error: You're already enrolled in that course"
        return @followers
    f = @followers
    f.push(user)
    @followers = f
    $.post(
      'follow/' + @id + '/' + user
    )


module.exports = Course