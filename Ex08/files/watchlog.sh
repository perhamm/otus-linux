#!/bin/bash

WORD=""
LOGFILE=""
TAILLINE=0 #how match line to tail
no_new_content=0 #no new line in log if no_new_content=1
lockfile=watchlog_lockfile
lastlinefile=watchlog_lastline
txtoutput=""
lastdate=""

## functions

script_usage(){
  echo -e "\e[31mUsage\e[0m: \e[42m`basename $0` WORD LOGFILE\e[0m"
  echo "Examples: ./watchlog.sh \"session opened for user root\" /var/log/secure"
  kill -INT $$
}

send_log(){
    echo $txtoutput >> /var/log/watchlog.log
}


## actions


get_runtime_interval_and_check_tmp_file(){
  if [ ! -f "$lastlinefile" ]       # Check if file exists.
    then
      echo "First run detected. The processing interval is from the time the file was created to script run date"
      echo "===================="
      echo "0" > "$lastlinefile"
      echo "`date`" >> "$lastlinefile"
      echo $LOGFILE >> "$lastlinefile"
      echo "sript run date: `date`"
    else
      if [[ "`tail -n1 "$lastlinefile"`" != "$LOGFILE" ]]
        then
          echo "Change in paramters detected! Clear last remebed line! The processing interval is from the time the file was created to script run date"
          echo "===================="
          echo "0" > "$lastlinefile"
          echo "`date`" >> "$lastlinefile"
          echo $LOGFILE >> "$lastlinefile"
          echo "sript run date: `date`"
      else  
        lastdate=`tail -n2 "$lastlinefile" | head -n1`
        echo "begin: $lastdate"
        echo "end: `date` "
        echo ""
      fi
  fi
}


get_number_of_line_to_parse(){
  TOTALLINE=`wc -l $LOGFILE  | awk '{print $1}'`
  LASTLINE=`head -n1 "$lastlinefile"`
  TAILLINE=$(( TOTALLINE - LASTLINE + 1))
  if (( $TAILLINE == 1))
    then
      echo "The processing interval has no content new log strings."
      echo "===================="
      no_new_content=1
  fi
  if (( $TAILLINE < 1))
    then
      TAILLINE=$TOTALLINE
      echo "Rotation error log detected."
      echo "===================="
  fi
  echo $TOTALLINE > "$lastlinefile"
  echo "`date`" >> "$lastlinefile"
  echo $LOGFILE >> "$lastlinefile"
}


get_word_in_log(){
  tail -n $TAILLINE $LOGFILE | grep "$WORD"  1> /dev/null
  if [ $? -eq 0 ]
  then 
    txtoutput="`date`: found string $WORD in $LOGFILE in interval from $lastdate to `date` 1 or mote times"
    echo "Something found... send msg to log file /var/log/watchlog.log"
    send_log
  else
    echo "nothing... exit"
  fi
}


## executing


if (set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
  then
    # set trap
    trap 'rm -f "$lockfile"; exit $?'  SIGHUP INT TERM EXIT KILL
    if ! (( $# == 2 ))  # Correct number of arguments passed to script?
    then
      echo "" 
      echo "!!!Please, use 2 arguments - Word or string and Log name!!!" 
      echo "" 
    script_usage
    fi
    WORD=${1}
    LOGFILE=${2}
    if [ -z "$WORD" ]
    then
      echo "" 
      echo "Word not set correctly... hmmm.... wtf =0" 
      echo "" 
      script_usage
    fi 
    if [ ! -f "$LOGFILE" ]
    then
      echo "" 
      echo "File \"$LOGFILE\" does not exist!" 
      echo "" 
      script_usage
    fi
    get_runtime_interval_and_check_tmp_file
    get_number_of_line_to_parse
    if (( $no_new_content == 0))
      then
        get_word_in_log
    fi

    rm -f "$lockfile"
    # unset trap
    trap - SIGHUP INT TERM EXIT KILL
  else
    echo "Failed to acquire lockfile: $lockfile."
    echo "Held by $(cat $lockfile)"
fi

