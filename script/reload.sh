#!/bin/bash
cd /opt/yooyoung/iron

rainbows_pidfile='tmp/pids/rainbows.pid'
sidekiq_pidfile='tmp/pids/sidekiq.pid'
rainbows_pid=`cat tmp/pids/rainbows.pid`
sidekiq_pid=`cat tmp/pids/sidekiq.pid`
user='rails'

if [ -f $rainbows_pidfile ]; then
  kill -USR2 $rainbows_pid
else
  bundle exec rainbows -c config/rainbows.rb -E production -D
fi

if [ -f $sidekiq_pidfile ]; then
  bundle exec sidekiqctl stop $sidekiq_pidfile
fi
bundle exec sidekiq -C config/sidekiq.yml -P $sidekiq_pidfile -L log/sidekiq.log -e production -d

while true; do
  sleep 10

  rainbows_num=`ps -ef | grep rainbows | grep master | grep $rainbows_pid | wc -l`

  if (( rainbows_num > 1 )) ; then
    kill -QUIT $rainbows_pid
    break
  fi
done
