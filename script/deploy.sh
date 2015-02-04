#!/bin/sh

cd /opt/yooyoung/iron
git pull
RAILS_ENV=production bundle exec rake assets:precompile
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake db:mongoid:create_indexes
sh script/reload.sh
