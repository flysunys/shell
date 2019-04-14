#!/bin/bash
#firstly,judge parameters number
if [ $# -gt 0 ]
then
  echo "parameter number is greater 0"
else
  echo "parameter number is 0, is illegal,please input corrent parameter number again"
  exit
fi
#secondly,receive input parameter
if [ -n $1 ]
then
  content=$1
else
  echo "content is default"
  content=asia,china,America,Japan
fi
if [ -n $2 ]
then
  repos=$2
else
  echo "repos is default"
  repos=ems,icm,ommb,rct
fi
if [ -n $3 ]
then
  branch=$3
else
  echo "branch is default"
  branch=master
fi
if [ -n $4 ]
then
  search_type=$4
else
  echo "search_type is default"
  search_type=file
fi
if [ -n $5 ]
then
  exclude_content=$5
else
  echo "exclude_content is default"
  exclude_content=male,jdk
fi
echo "************all parameters*********************"
echo "content is $content"
echo "repos is $repos"
echo "branch is $branch"
echo "search_type is $search_type"
echo "exclude_content is $exclude_content"

