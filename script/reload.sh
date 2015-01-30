#!/bin/bash
cd /opt/yooyoung/iron

rainbows_pid=`cat tmp/pids/rainbows.pid`
sidekiq_pid=`cat tmp/pids/sidekiq.pid`
user='rails'

if [ -f $rainbows_pid ]; then
  kill -USR2 $rainbows_pid
else
  bundle exec rainbows -c config/rainbows.rb -E production -D
fi

if [ -f $sidekiq_pid ]; then
  bundle exec sidekiqctl stop $sidekiq_pid
fi
pkill -u $user -f 'sidekiq [0-9]'
bundle exec sidekiq -C config/sidekiq.yml -e production -d

while true; do
  sleep 10

  rainbows_num=`ps -ef | grep rainbows | grep master | grep $rainbows_pid | wc -l`

  if (( rainbows_num > 1 )) ; then
    kill -QUIT $rainbows_pid
    break
  fi
done
