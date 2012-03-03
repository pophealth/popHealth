#!/bin/bash
QUEUE=* bundle exec rake resque:work RAILS_ENV=production

