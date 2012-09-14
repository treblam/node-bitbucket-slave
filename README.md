# BitBucket Slave

BitBucket Slave is a web service, whicn listen for POST requests from BitBucket repositories
and update local repository from BitBucket remote.

It's realy simple and stupid. Look into `config.example.json` for configuration example. 
Move it to `config.json`, change paths to remote origins and local working copies, and run `coffee ./app.coffee`.

## Installation

It needs to node.js and npm has been installed.

* get BitBucket Slave copy `git clone https://github.com/kaero/node-bitbucket-slave.git`
* install coffee-script package globally running `npm -g install coffee-script`
* install dependencies running `npm install`
* copy configuration example to actual configuration location: `cp ./config.example.json ./config.json`
* change example repository paths in the `config.json` to you own
* run BitBucket Slave server `coffee ./app.coffee &>/dev/null &`
* check that it runs correctly `curl -X GET http://127.0.0.1:10101/`
* configure your http-proxy if needed to proxy requests for BitBucket Slave to `127.0.0.1:10101` or change binding address in the `app.coffee`
* setup a POST service for your BitBucket repository to send requests to BitBucket Slave
* enjoy!

## Usage

Oh, simply write `#deply` in the commit message and push changes to BitBucket remote.
