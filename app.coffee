express = require 'express'
exec    = require('child_process').exec
config  = require './config.json'

require 'sugar'

app = express()

app.use express.bodyParser()
app.use app.router

app.get '/*', (req, res) ->
  res.send 'Hello!'

app.post '/', (req, res) ->
  payload = JSON.parse req.body.payload

  bburl = payload.canon_url + payload.repository.absolute_url
  local = config[bburl]?.local

  if local and payload.commits.count((commit)-> /#deploy/.test(commit.message))
    exec 'git pull', { cwd: local }, (err, stdout, stderr)->
      if err
        res.send 'deployment has been failed'
      else
        res.send 'ok'

app.listen 10101, '127.0.0.1'
