#!/bin/bash
set -e

if [ "$1" = 'mysqlsh' ]; then

    if [[ -z $MYSQL_HOST1 || -z $MYSQL_HOST2 || -z $MYSQL_HOST3 || -z $MYSQL_PORT || -z $MYSQL_USER || -z $MYSQL_PASSWORD ]]; then
	    echo "We require all of"
	    echo "    MYSQL_HOST1..3"
	    echo "    MYSQL_PORT"
	    echo "    MYSQL_USER"
	    echo "    MYSQL_PASSWORD"
	    echo "to be set. Exiting."
	    exit 1
    fi
    max_tries=48
    attempt_num=0
    until (echo > "/dev/tcp/$MYSQL_HOST1/$MYSQL_PORT") >/dev/null 2>&1; do
	    echo "Waiting for mysql server $MYSQL_HOST ($attempt_num/$max_tries)"
	    sleep $(( attempt_num++ ))
	    if (( attempt_num == max_tries )); then
		    exit 1
	    fi
    done
    until (echo > "/dev/tcp/$MYSQL_HOST2/$MYSQL_PORT") >/dev/null 2>&1; do
	    echo "Waiting for mysql server $MYSQL_HOST ($attempt_num/$max_tries)"
	    sleep $(( attempt_num++ ))
	    if (( attempt_num == max_tries )); then
		    exit 1
	    fi
    done
    until (echo > "/dev/tcp/$MYSQL_HOST3/$MYSQL_PORT") >/dev/null 2>&1; do
	    echo "Waiting for mysql server $MYSQL_HOST ($attempt_num/$max_tries)"
	    sleep $(( attempt_num++ ))
	    if (( attempt_num == max_tries )); then
		    exit 1
	    fi
    done
    if [ "$MYSQLSH_SCRIPT" ]; then
	mysqlsh "$MYSQL_USER@$MYSQL_HOST1:$MYSQL_PORT" --password="$MYSQL_PASSWORD" -f "$MYSQLSH_SCRIPT" || true
    fi
    if [ "$MYSQL_SCRIPT" ]; then
	mysqlsh "$MYSQL_USER@$MYSQL_HOST1:$MYSQL_PORT" --password="$MYSQL_PASSWORD" --sql -f "$MYSQL_SCRIPT" || true
    fi
	echo 'Вроде все ок! Запустите docker exec -ti innodb-cluster_mysql-shell_1  /bin/bash  для проверки статуса... я бужу ждать :) очень ОЧЕНЬ долго ждать...'  >> /proc/1/fd/1
    while :; do sleep 2073600; done
fi

exec "$@"


