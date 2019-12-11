#!/bin/bash

COUNT=5
NICE1=19
NICE2=-20
lockfile=cpunice


run_dd(){
  start=`date +%s%N`
  nice -n $2 dd if=/dev/urandom bs=64M count=$1 iflag=fullblock 2> /dev/null |nice -n $2 gzip > /dev/null 
  end=`date +%s%N`
  runtime=$(($((end-start))/1000000))
  seconds=$((runtime / 1000))
  milliseconds=$((runtime % 1000))
  echo "Process dd and gzip with nice = $2 execution of $seconds.$milliseconds seconds."
}

## executing

if (set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
  then
    # set trap
    trap 'rm -f "$lockfile"; exit $?'  SIGHUP INT TERM EXIT KILL
    echo "Run nice -n $NICE1 dd if=/dev/urandom bs=64M count=$COUNT iflag=fullblock 2> /dev/null |nice -n $NICE1 gzip > /dev/null... please waiting"
    run_dd $COUNT $NICE1 &
    echo "Run nice -n $NICE2 dd if=/dev/urandom bs=64M count=$COUNT iflag=fullblock 2> /dev/null |nice -n $NICE2 gzip > /dev/null... please waiting"
    run_dd $COUNT $NICE2 &
    wait $(jobs -p)
    # unset trap
    rm -f "$lockfile"
    trap - SIGHUP INT TERM EXIT KILL
  else
    echo "Failed to acquire lockfile: $lockfile."
    echo "Held by $(cat $lockfile)"
fi