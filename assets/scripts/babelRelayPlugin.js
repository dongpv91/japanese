'use strict'

const getBabelRelayPlugin = require('babel-relay-plugin')
const introspectionQuery = require('graphql/utilities').introspectionQuery
const request = require('sync-request')

const HOST_URL = "http://localhost:4000/graphql"

const response = request('POST', HOST_URL, {
  json: {
    query: introspectionQuery
  }
})

const schema = JSON.parse(response.body.toString('utf-8'))
module.exports = { plugins: [getBabelRelayPlugin(schema.data, { abortOnError: true })] }
