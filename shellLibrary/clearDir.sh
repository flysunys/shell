#!/bin/bash
#clear Dir
if [ -n "$1" ]
then
  echo "need clear dir is $1"
else
  echo "need a parameter "
  exit -1
fi

if [ -d "$1" ]
then
  rm -rf "$1"
fi

mkdir -p "$1"
