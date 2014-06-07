express = require 'express'
execFile    = require('child_process').execFile
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
  console.log 'post requested.'
  res.send 'the post hook was received.'

  if local and payload.commits.count((commit)-> /#deploy/.test(commit.message))
    console.log 'start to execute file.'
    execFile '/home/ec2-user/projects/node-bitbucket-slave/deploy.sh', { cwd: local }, (err, stdout, stderr)->
      if err
        console.log 'error ocurred.'
        console.log err
      else
        console.log('result ok.')

app.listen 10101, '127.0.0.1'
