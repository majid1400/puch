#!/bin/bash

while true; do
  case $1 in
  -u)
    url=$2
    shift 2
    ;;
  -s)
    time=$2
    shift 2
    ;;
  -f)
    fail=$2
    shift 2
    ;;
  *)
    if [[ $# -eq 0 ]]; then
      break
    fi
    echo 'Unknown'
    exit 1
    ;;
  esac
done

COUNTER=0
while true; do
  ping -c1 $url >/dev/null
  if [ $? -eq 0 ]; then
    status=$(curl --write-out '%{http_code}' --silent --output /dev/null $url)
    if [[ $status == 200 ]] || [[ $status == 301 ]] || [[ $status == 302 ]]; then
      echo "ping and curl ok"
      exit 1
    else
      echo 'fail status code: ' $status
      let COUNTER++
      sleep $time
    fi
  else
    echo 'not ping'
    let COUNTER++
    sleep $time
  fi
  if [ $COUNTER -eq $fail ]; then
    echo "Counter: $COUNTER times reached; Exiting loop!"
    exit 0
  fi
done
