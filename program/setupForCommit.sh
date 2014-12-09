#!/bin/bash
cd ../
cd content
git init
echo "Local repository created."
git checkout --orphan development
echo "Branch 'development' created"
git remote add origin "https://github.com" 2> error.txt
if [ -f "error.txt" ] && [[ $(cat error.txt) != "" ]]
then
  rm -rf error.txt
else
  git remote remove origin
  git remote add origin $1
  rm -rf error.txt
fi
git pull origin development
