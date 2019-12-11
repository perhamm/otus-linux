#!/bin/bash


X=${X:-10}
Y=${Y:-10}
LOGFILE="${LOGFILE:-/var/log/nginx/access.log}"
LOGFILEERROR="${LOGFILEERROR:-/var/log/nginx/error.log}"
EMAIL="${EMAIL:-root@localhost}"
TAILLINE=0 #how match line to tail
no_new_content=0 #no new line in log if no_new_content=1
TAILLINEERROR=0 #how match line to tail in error log 
no_new_content_error=0 #no new line in error log if no_new_content_error=1
lockfile=analyze_nginx_logs_lockfile
lastlinefile=analyze_nginx_logs_lastline
txtoutput=analyze_nginx_logs_lastemailbody

## functions

script_usage(){
  echo -e "\e[31mUsage\e[0m: \e[42m`basename $0` --nginx_log_name FILENAME --nginx_error_log_name FILENAME --number_top_ip X --number_top_pages Y --email E-MAIL\e[0m"
  echo -e "\e[31mnginx_log_name \e[0m- nginx file log name for parse"
  echo -e "\e[31mnginx_error_log_name \e[0m- nginx file log name for parse"
  echo -e "\e[31mnumber_top_ip \e[0m- number of top request ip to print"
  echo -e "\e[31mnumber_top_pages \e[0m- number of top request pages to print"
  echo -e "\e[31memail \e[0m- email to send info"
  echo "deafult nginx_log_name /var/log/nginx/access.log"
  echo "deafult nginx_error_log_name /var/log/nginx/error.log"
  echo "deafult number_top_ip 10"
  echo "deafult number_top_pages 10"
  echo "deafult email root@localhost"
  echo "Examples: ./analyze_nginx_logs.sh --nginx_log_name application.access.log --nginx_error_log_name error.log"
  echo "--------- ./analyze_nginx_logs.sh --nginx_log_name /var/log/nginx/access.log --nginx_error_log_name /var/log/nginx/error.log --number_top_ip 20 --number_top_pages 20 --email voskresenskijas@ctd.tn.corp"
  kill -INT $$
}

request_ips(){
  awk '{print $1}'
}

request_pages(){
  awk '{print $6}' FPAT='[^ ]*|"[^"]*"' | awk '{if($2 != ""){print $2}}'
}

response_code(){
  awk '{print $7}' FPAT='[^ ]*|"[^"]*"'
}


wordcount(){
  sort | uniq -c
}

sort_desc(){
  sort -rn
}

return_kv(){
  awk '{print $1, $2}'
}

return_top(){
  head -$1
}

send_mail(){
    (
      echo "To: $EMAIL"
      echo "Subject: Nginx log parser"
      echo "Content-Type: text/html"
      echo
      cat  $txtoutput
      echo      
    ) | /usr/sbin/sendmail -t
}


## actions

check_argv(){
  if ! [ -x "$(command -v sendmail)" ]; then
    echo 'Error: sendmail is not installed. Please install sendmail (apt-get install sendmail  or  yum install sendmail or dnf install sendmail )'
    kill -INT $$
  fi
  if (( $# > 8 ))  # Correct number of arguments passed to script?
  then
    echo "" 
    echo "!!!Too many argumets!!!" 
    echo "" 
    script_usage
  fi
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      --nginx_log_name)
        LOGFILE=$2
        #echo "$LOGFILE" 
        if [[ -z $(echo "$LOGFILE" | sed -n '/.*\.log$/p') ]] 
        then
          echo "" 
          echo "!!!Log name must end with .log!!!" 
          echo "" 
          script_usage
        fi
        shift 2
        ;;
      --nginx_error_log_name)
        LOGFILEERROR=$2
        #echo "$LOGFILEERROR" 
        if [[ -z $(echo "$LOGFILEERROR" | sed -n '/.*\.log$/p') ]] 
        then
          echo "" 
          echo "!!!Log name must end with .log!!!" 
          echo "" 
          script_usage
        fi
        shift 2
        ;;
      --number_top_ip)
        X=$2
        if ! [[ "$X" =~ ^[0-9]+$ && (("$X" > 0))]] 
          then 
            echo "" 
            echo "Sorry, number_top_ip must be numeric and more or equal 1." 
            echo "" 
            script_usage
        fi
        shift 2
        ;;
      --number_top_pages)
        Y=$2
        if ! [[ "$Y" =~ ^[0-9]+$ && (("$Y" > 0))]] 
          then 
            echo ""
            echo "Sorry, number_top_pages must be numeric and more or equal 1."
            echo ""
            script_usage
        fi
        shift 2
        ;;
      --email)
        EMAIL=$2
        if ! [[ "$EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}|localhost$ ]] 
          then 
            echo ""
            echo "Sorry, email is not valid."
            echo ""
            script_usage
        fi
        shift 2
        ;;
      --) # end argument parsing
        shift
        break
        ;;
      -*|--*=) # unsupported flags
        echo ""
        echo "Sorry, unsupported flags."
        echo ""
        script_usage
        ;;
      *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
  done # set positional arguments in their proper place
  eval set -- "$PARAMS"
  if [ ! -f "$LOGFILE" ]       # Check if file in default value (/var/log/nginx/access.log) or set in while exists 
    then
    echo "" 
    echo "File \"$LOGFILE\" does not exist!" 
    echo "" 
    script_usage
  fi
  if [ ! -f "$LOGFILEERROR" ]       # Check if file in default value (/var/log/nginx/error.log) or set in while exists 
    then
    echo "" 
    echo "File \"$LOGFILEERROR\" does not exist!" 
    echo "" 
    script_usage
  fi
}

get_runtime_interval_and_check_tmp_file(){
  echo "Interval to parse log:"
  echo "====================="
  if [ ! -f "$lastlinefile" ]       # Check if file exists.
    then
      echo "First run detected. The processing interval is from the time the file was created to script run date"
      echo "===================="
      echo "0" > "$lastlinefile"
      echo "0" >> "$lastlinefile"
      echo "`date`" >> "$lastlinefile"
      echo $LOGFILE >> "$lastlinefile"
      echo "sript run date: `date`"
    else
      if [[ "`tail -n1 "$lastlinefile"`" != "$LOGFILE" ]]
        then
          echo "Change in paramters detected! Clear last remebed line! The processing interval is from the time the file was created to script run date"
          echo "===================="
          echo "0" > "$lastlinefile"
          echo "0" >> "$lastlinefile"
          echo "`date`" >> "$lastlinefile"
          echo $LOGFILE >> "$lastlinefile"
          echo "sript run date: `date`"
      else  
        echo "begin: `tail -n2 "$lastlinefile" | head -n1` "
        echo "end: `date` "
        echo ""
      fi
  fi
}


get_number_of_line_to_parse(){
  TOTALLINE=`wc -l $LOGFILE  | awk '{print $1}'`
  LASTLINE=`head -n1 "$lastlinefile"`
  TAILLINE=$(( TOTALLINE - LASTLINE + 1))
  TOTALLINEERROR=`wc -l $LOGFILEERROR  | awk '{print $1}'`
  LASTLINEERROR=`head -n2 "$lastlinefile"| tail -n1`
  TAILLINEERROR=$(( TOTALLINEERROR - LASTLINEERROR + 1))
  if (( $TAILLINE == 1))
    then
      echo "The processing interval has no content log strings."
      echo "===================="
      no_new_content=1
  fi

  if (( $TAILLINE < 1))
    then
      TAILLINE=$TOTALLINE
      echo "Rotation error log detected."
      echo "===================="
  fi

  if (( $TAILLINEERROR == 1))
    then
      echo "The processing interval has no content with new string in error log."
      echo "===================="
      no_new_content_error=1
  fi

  if (( $TAILLINEERROR < 1))
    then
      TAILLINEERROR=$TOTALLINEERROR
      echo "Rotation log detected in error log."
      echo "===================="
  fi
  
  echo $TOTALLINE > "$lastlinefile"
  echo $TOTALLINEERROR >> "$lastlinefile"
  echo "`date`" >> "$lastlinefile"
  echo $LOGFILE >> "$lastlinefile"
}


get_request_ips(){
  echo ""
  echo "Top $X Request IP's:"
  echo "===================="
  tail -n $TAILLINE $LOGFILE | request_ips | wordcount | sort_desc | return_kv | return_top $X
  echo ""
}

get_request_pages(){
  echo "Top $Y Request Pages:"
  echo "====================="
  tail -n $TAILLINE $LOGFILE | request_pages | wordcount | sort_desc | return_kv | return_top $Y
  echo ""
}

get_response_code(){
  echo "Response Codes:"
  echo "====================="
  tail -n $TAILLINE $LOGFILE | response_code | wordcount | sort_desc | return_kv
  echo ""
}

get_error_log(){
  echo "All error log from the last start:"
  echo "====================="
  tail -n $TAILLINEERROR $LOGFILEERROR
  echo ""
}


## executing


if (set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
  then
    # set trap
    trap 'rm -f "$lockfile"; exit $?'  SIGHUP INT TERM EXIT KILL
    echo "=========================================="  > $txtoutput
    check_argv $@
    get_runtime_interval_and_check_tmp_file  >> $txtoutput
    get_number_of_line_to_parse  >> $txtoutput
    if (( $no_new_content == 0))
	  then
	    get_request_ips  >> $txtoutput
        get_request_pages  >> $txtoutput
        get_response_code  >> $txtoutput
    fi
	if (( $no_new_content_error == 0))
	  then
	    get_error_log  >> $txtoutput
    fi
    send_mail
    rm -f "$lockfile"
    # unset trap
    trap - SIGHUP INT TERM EXIT KILL
  else
    echo "Failed to acquire lockfile: $lockfile."
    echo "Held by $(cat $lockfile)"
fi

