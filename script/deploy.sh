#!/bin/sh

cd /opt/yooyoung/iron
git pull
RAILS_ENV=production bundle exec rake assets:precompile
RAILS_ENV=production bundle exec rake db:migrate
sh script/reload.sh
