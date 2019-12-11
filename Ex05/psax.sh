#!/bin/bash


get_value(){
  clktck=` getconf CLK_TCK `
  pid=`cat $1/status | grep '^Pid' | awk '{print $2}'`
  fd0=`ls -l $1/fd/0 2> /dev/null | grep dev | grep -v null| awk '{print $11}' | sed -r 's/\/dev\///'`
  if [ -z "$fd0" ]
    then
      fd0="?"
  fi
  name=`cat $1/status | grep '^Name' | awk '{print $2}'`
  status=`cat $1/status | grep '^State' | awk '{print $2}'`
  utime=`cat $1/stat | awk '{print $14}'`
  stime=`cat $1/stat | awk '{print $15}'`
  p_time=$(( (utime + stime) / $clktck ))
  minutes=$((p_time / 60))
  seconds=$((p_time % 60))
  s=`cat $1/cmdline | tr -d '\0'` 
  if ! [ -z "$s" ] 
    then
      printf "%5s %-8s %-3s %4d:%02d " "$pid" "$fd0" "$status" "$minutes" "$seconds"; echo `cat $1/cmdline | tr -d '\0'`
    else
      printf "%5s %-8s %-3s %4d:%02d [%s]\n" "$pid" "$fd0" "$status" "$minutes" "$seconds" "$name"
  fi
}









printf "%5s %-8s %-3s %6s %s\n" `echo PID` `echo TTY` `echo STAT` `echo TIME` `echo COMMAND`

for proc in `ls /proc | egrep ^[0-9]+$ | sort -n`
  do
    [ -d "/proc/$proc" ]  && get_value /proc/$proc
done