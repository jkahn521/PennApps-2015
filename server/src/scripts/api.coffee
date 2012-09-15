# config     = require '../config'
# utils      = require '../utils/amplifyme'
{resp}     = require './response'
fs = require 'fs'
# sys = require 'sys'

csv = require 'csv'

exports.courses_csv = (req, res) ->

    results = []

    csv()
    .fromPath(__dirname + '/../../../class_data.csv')
    .on('data', (data, index) ->

        results.push(data)
    )
    .on('end', ->
        res.send(results)
    )

    