mongod &
~/Programs/redis-2.4.16/src/redis-server &
QUEUE=* bundle exec rake resque:work