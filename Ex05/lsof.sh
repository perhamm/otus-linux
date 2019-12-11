#!/bin/bash

get_value(){

  name=`cat $1/status | grep Name | awk '{print $2}'`
  pid=`cat $1/status | grep '^Pid' | awk '{print $2}'`
  uid=`cat $1/status | grep Uid |  awk '{print $2}'`
  username=`getent passwd $uid | cut -d: -f1`
  
  
  for fd in `ls -l $1/fd | tail -n +2 | awk '{print $11}'`
    do
     
      if [[ $fd =~ "socket" ]]
      then
        socket=`echo $fd | cut -d ":"  -f 2 | sed 's/]$//g' | sed 's/^[[]//g'`
        cat /proc/net/tcp | grep $socket 1>/dev/null
        if [ $? -eq 0 ] 
        then
          printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo TCP` `echo $fd`
          continue
        fi
        cat /proc/net/tcp6 | grep $socket 1>/dev/null
        if [ $? -eq 0 ] 
        then
          printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo TCP6` `echo $fd`
          continue
        fi
        cat /proc/net/udp | grep $socket 1>/dev/null
        if [ $? -eq 0 ] 
        then
          printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo UDP` `echo $fd`
          continue
        fi
        cat /proc/net/udp6 | grep $socket 1>/dev/null
        if [ $? -eq 0 ] 
        then
          printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo UDP6` `echo $fd`
          continue
        fi
        cat /proc/net/unix | grep $socket 1>/dev/null
        if [ $? -eq 0 ] 
        then
          printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo UNIX` `echo $fd`
          continue
        fi
        printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo -` `echo $fd`
        continue
      fi
      if [[ $fd =~ ^pipe.* ]]
      then
        printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo FIFO` `echo $fd`
        continue
      fi
      if [[ $fd =~ ^/dev/.*|^/sys.*|^/run.* ]]
      then
        printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo -` `echo $fd`
        continue
      fi
      
      if [[ $fd =~ ^\/.* ]]
      then
        if [ -f $fd ]
          then
            inode=`ls -li $fd | awk '{print $1}'`
            size=`ls -li $fd | awk '{print $6}'`
            printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo $size` `echo $inode` `echo $fd`
            continue
          else
            printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo DELETED` `echo $fd`
            continue
        fi
      fi
      printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo $name` `echo $pid` `echo $username` `echo -` `echo -` `echo $fd`
  done
  
}


printf "%-20s %-7s %-15s %-15s %-15s %s\n" `echo COMMAND` `echo PID` `echo USER` `echo SIZE` `echo NODE/TYPE` `echo NAME`

for proc in `ls /proc | egrep ^[0-9]+$ | sort -n`
  do
    [ -d "/proc/$proc" ]  && get_value /proc/$proc
done