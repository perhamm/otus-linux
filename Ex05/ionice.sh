#!/bin/bash


IONICE1=0
IONICE2=7
lockfile=ionice


generate_file(){
dd if=/dev/urandom of=/opt/test1 bs=1M count=10240
}

run_dd(){
  start=`date +%s%N`
  ionice -c1 -n$1 dd if=/opt/test1 of=/opt/test_ionice_$1 bs=1M iflag=direct 2> /dev/null
  end=`date +%s%N`
  runtime=$(($((end-start))/1000000))
  seconds=$((runtime / 1000))
  milliseconds=$((runtime % 1000))
  echo "Process dd with ionice = $1 execution of $seconds.$milliseconds seconds."
}


## executing

if (set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
  then
    # set trap
    trap 'rm -f "$lockfile"; rm -f /opt/test_ionice_$IONICE1; rm -f /opt/test_ionice_$IONICE2; exit $?'  SIGHUP INT TERM EXIT KILL
    echo "generate big file... please wait"
    generate_file
    echo "Run ionice -c1 -n$IONICE1 dd if=/opt/test1 of=/opt/test_ionice_$IONICE1 bs=1M iflag=direct 2> /dev/null... please waiting"
    run_dd $IONICE1 &
    echo "Run ionice -c1 -n$IONICE2 dd if=/opt/test1 of=/opt/test_ionice_$IONICE2 bs=1M iflag=direct 2> /dev/null... please waiting"
    run_dd $IONICE2 &
    wait $(jobs -p)
    echo "delete generated file"
    rm -f /opt/test_ionice_$IONICE1
    rm -f /opt/test_ionice_$IONICE2
    rm -f /opt/test1
    echo "done"
    rm -f "$lockfile"
    # unset trap
    trap - SIGHUP INT TERM EXIT KILL
  else
    echo "Failed to acquire lockfile: $lockfile."
    echo "Held by $(cat $lockfile)"
fi