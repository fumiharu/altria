# Magi
A continuous integration server implementation.

## Install
```
$ gem install magi
$ brew install mysql redis # or other commands to install MySQL and Redis
```

## Usage
```
$ gem install magi
$ magi setup
$ magi start # open http://localhost:3000
```

## Hack
Magi is just a rails application.
Feel free to do what you want and send pull-requests.

### tools
* Rails: HTTP server
* Sidekiq: background worker
* Redis: worker queue
* MySQL: store jobs & builds

### todo
* scheduling system
* plugin system
* cli options (e.g. http port, rails env, redis conf)
