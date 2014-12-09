#!/bin/bash
read -ep "Enter your repo url(https://github.com/<user>/<repository>.git: " input
./setupForCommit.sh $input
./setupForPublish.sh $input