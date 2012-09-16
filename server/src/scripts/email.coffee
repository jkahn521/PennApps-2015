email_user = (user, course) ->
  console.log 'EMAIL USER'

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

check_course_helper = ->
  console.log 'check course helper'