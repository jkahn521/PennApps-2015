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

  mailOptions = {
    from: "Course Alert <mycoursealert@gmail.com>", 
    to: "pennappsdemo@gmail.com",
    subject: "Course Alert", 
    text: "", 
    html: "HTML COURSE" 
  }

  # smtpTransport.sendMail(mailOptions, (error, response) ->
  #   if(error)
  #     console.log(error)
  #   else
  #     console.log("Message sent: " + response.message)
  #     res.send('Email was sent')
  # )

exports.check_courses = ->
  console.log 'check courses'
  check_course_helper()

check_course_helper = ->
  console.log 'check course helper'
  # check if each course is open

  # email_data = []

  csv()
  .fromPath(__dirname + '/../../../class_data.csv')
  .on('data', (data, index) ->

    f = []

    for name, i in data when i > 1
      f.push(name)

    # email_data.push({id: data[0], status: data[1], followers: f})
    if(data[1] == 'OPEN')
      for follower in f
        email_user(follower, data[0])
    

  )
  .on('end', ->
      
  )    


