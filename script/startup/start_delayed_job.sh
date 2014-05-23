#!/bin/bash
cd /home/pophealth/popHealth
. /usr/local/rvm/scripts/rvm
./script/delayed_job -n1 --queue=calculation --pid-dir=./pids/calculation_workers $1
./script/delayed_job -n1 --queue=patient_import --pid-dir=./pids/import_workers $1
./script/delayed_job -n1 --queue=rollup --pid-dir=./pids/rollup_workers $1



start on started mongodb
stop on stopping mongodb

script
exec sudo -u pophealth /home/pophealth/start_delayed_job.sh >> /tmp/delayed_worker.log 2>&1
end script
' > /tmp/delayed_worker.conf
    