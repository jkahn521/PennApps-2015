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

        results.push({id: data[0], status: data[1]})
    )
    .on('end', ->
        res.send(results)
    )

    