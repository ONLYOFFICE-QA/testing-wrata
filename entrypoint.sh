#!/usr/bin/env sh

rm -f /root/wrata/tmp/pids/server.pid
RAILS_ENV=production rake db:create db:migrate db:seed
bundle exec rails s -p 3000 -b '0.0.0.0' --environment=production