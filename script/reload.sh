#!/bin/bash

PID=`cat tmp/pids/rainbows.pid`

# kill -USR2
kill -USR2 $PID
bundle exec rake sidekiq:stop
bundle exec rake sidekiq:start

while true; do
  sleep 10

  num=`ps -ef | grep rainbows | grep master | grep $PID | wc -l`

  if (( num > 1 )) ; then
    kill -QUIT $PID
    break
  fi
done
