#!/bin/sh
# This script destroys all the contents of the clinical_documents directory, and
# destroys and rebuilds the database. Clearing the clinical_documents is critical
# in keeping sync between the filesystem and the database.
while true
do
  echo -n "Are you sure?! (y or n) :"
  read CONFIRM
  case $CONFIRM in
    y|Y|YES|yes|Yes) break ;;
    n|N|no|NO|No)
    echo Aborting...
    exit
  ;;
  *) echo Please enter only y or n
  esac
  done

echo Continuing...
cd ..
echo "Deleting contents of public/clinical_documents"
rm -rf public/clinical_documents/*
rake db:drop db:create db:migrate
rake db:fixtures:load_from_dir env="development" FIXTURE_DIR="spec/fixtures" --trace
cd bin
