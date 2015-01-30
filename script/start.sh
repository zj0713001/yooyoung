#!/bin/sh

cd /opt/yooyoung/iron
bundle exec rainbows -c config/rainbows.rb -E production -D
bundle exec sidekiq -C config/sidekiq.yml -e production -d
