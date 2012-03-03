#!/bin/bash
cd /home/pophealth/popHealth
. /usr/local/rvm/scripts/rvm
QUEUE=* bundle exec rake resque:work RAILS_ENV=production
