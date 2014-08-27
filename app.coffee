express = require 'express'
exec = require('child_process').exec
execFile = require('child_process').execFile
config  = require './config.json'
bodyParser = require 'body-parser'
router = express.Router()

require 'sugar'

app = express()

app.use bodyParser.json()
app.use bodyParser.urlencoded()

app.use '/', router

router.get '/*', (req, res) ->
  console.log 'get requested.'
  res.send 'Hello!'

router.post '/', (req, res) ->
  payload = JSON.parse req.body.payload

  bburl = payload.canon_url + payload.repository.absolute_url
  local = config[bburl]?.local
  /\/([\w]+)\/$/.test(bburl)
  projectName = RegExp.$1
  console.log 'post requested.'
  console.log 'projectName:', projectName
  console.log 'local:', local
  res.send 'the post hook was received.'

  if local and payload.commits.count((commit)-> /#deploy/.test(commit.message))
    console.log 'start to execute.'
    exec 'git pull && pm2 reload ' + projectName, { cwd: local }, (err, stdout, stderr)->
      if err
        console.log 'error ocurred.'
        console.log err
      else
        console.log 'result ok.'

app.listen 10101, '127.0.0.1'
