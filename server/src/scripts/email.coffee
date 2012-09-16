nodemailer = require 'nodemailer'
csv = require 'csv'

email_user = (user, course) ->

  console.log 'EMAIL USER'
  console.log 'SENDING EMAIL TO' + user + 'for' + course
  

  smtpTransport = nodemailer.createTransport("SMTP",{
    service: "Gmail",
    auth: {
        user: "mycoursealert@gmail.com",
        pass: "pennapps15"
    }
  })

  d = new Date().getTime()

  mailOptions = {
    from: "Course Alert <mycoursealert@gmail.com>", 
    to: "pennappsdemo@gmail.com",
    subject: "Course Alert", 
    text: "", 
    html: '<p id="to">Student,</p>
          <p id="body">Your desired class is open for registration as of ' + d + '. You can register now at https://medley09.isc-seo.upenn.edu/pennInTouch/</p>
          <p id="end">Happy Registering!</p>'
  }

  smtpTransport.sendMail(mailOptions, (error, response) ->
    if(error)
      console.log(error)
    else
      console.log("Message sent: " + response.message)
  )

exports.check_courses = ->
  console.log 'check courses'
  check_course_helper()

check_course_helper = ->
  console.log 'check course helper'

  csv()
  .fromPath(__dirname + '/../../../class_data.csv')
  .on('data', (data, index) ->

    f = []

    for name, i in data when i > 1
      f.push(name)

    if(data[1] == 'OPEN')
      for follower in f
        email_user(follower, data[0])


  )
  .on('end', ->
      setTimeout(check_course_helper, 10000)
  )    


