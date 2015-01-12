#!/usr/bin/env puma
environment 'production'

bind 'unix:///opt/yooyoung/iron/tmp/sockets/iron.socket'
bind 'tcp://127.0.0.1:3000'
pidfile 'tmp/pids/puma.pid'

daemonize
stdout_redirect 'log/stdout', 'log/stderr'

threads 8,32
workers 2
preload_app!

tag 'iron_production'
worker_timeout 180

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
