#!/usr/bin/env ruby
trap("SIGHUP") { Process.kill(:TERM, $pid) }

$pid = fork

if $pid == nil
  exec "redis-server /usr/local/etc/redis.conf"
end

Process.wait