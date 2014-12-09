#!/bin/bash
cd ../
cd content
git remote add origin "https://github.com" 2> error.txt
if [ -f "error.txt" ] && [[ $(cat error.txt) != "" ]]
then
  rm -rf error.txt
else
  git remote remove origin
  read -ep "Enter your repo url(https://github.com/<user>/<repository>.git: " input
  git remote add origin $input
  rm -rf error.txt
fi
git pull origin development