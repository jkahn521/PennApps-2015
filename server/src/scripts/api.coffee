# config     = require '../config'
# utils      = require '../utils/amplifyme'
{resp}     = require './response'
fs = require 'fs'
# sys = require 'sys'

csv = require 'csv'

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