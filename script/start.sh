#!/bin/sh

cd /opt/yooyoung/iron
bundle exec rainbows -c config/rainbows.rb -E production -D
bundle exec sidekiq -C config/sidekiq.yml -P tmp/pids/sidekiq.pid -L log/sidekiq.log -e production -d
