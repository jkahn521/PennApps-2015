# config     = require '../config'
# utils      = require '../utils/amplifyme'
{resp}     = require './response'
fs = require 'fs'
# sys = require 'sys'

csv = require 'csv'
nodemailer = require 'nodemailer'

exports.all_courses_csv = (req, res) ->

  results = []

  csv()
  .fromPath(__dirname + '/../../../class_data.csv')
  .on('data', (data, index) ->

    f = []

    for name, i in data when i > 1
      f.push(name)

    results.push({id: data[0], status: data[1], followers: f})
  )
  .on('end', ->
      res.send(results)
  )    

exports.follow_course = (req, res) ->
  console.log 'follow course'
  console.log 'id is ' + req.params.id
  console.log 'course is ' + req.params.course

exports.send_email = (req, res) ->
  console.log 'send email'

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
    text: "You have a course alert for COURSE", 
    html: "HTML COURSE" 
  }

  smtpTransport.sendMail(mailOptions, (error, response) ->
    if(error)
      console.log(error)
    else
      console.log("Message sent: " + response.message)
  )

  res.send('email sent')