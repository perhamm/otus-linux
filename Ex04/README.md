Для тестового запуска:

curl -L https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex4/analyze_nginx_logs.sh -o analyze_nginx_logs.sh

сurl -L https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex4/zabbix.access.log -o  zabbix.access.log

curl -L https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex4/error.log -o  error.log

chmod +x analyze_nginx_logs.sh

./analyze_nginx_logs.sh --nginx_log_name zabbix.access.log --nginx_error_log_name error.log

cat /var/spool/mail/root

Для боевого указать, например в кроне, 0 * * * * root cd /root && ./analyze_nginx_logs.sh  --nginx_log_name /var/log/nginx/zabbix.access.log --nginx_error_log_name /var/log/nginx/error.log 



Постарался выполнить все условия, в  том числе про трапы и функции. Единственное - не смог найти куда find закинуть ))<br/>
Ввиду того, что в большинстве случаев error log для nginx ведется отдельно, для выполнения условия <br/>
- все ошибки c момента последнего запуска<br/>
<br/>
постарался скриптом обработать оба лога - как access, так и error, причем с момента последнего запуска. Если лог не содержит новых записей, срипт сообщает об этом.<br/>
Если файлов логов не существует ( как access, так и error), срипт сообщит о невомзожности запуска с примерами как надо его запускать. Если неправильно указаны флаги, лог файлы не заканчиваются на .log, указаны неверные значения X и Y ( пункт 1 и 2 в ДЗ), скрипт постарается об этом сообщить. Также при изменении имени access лога, произойдет сброс параметров обработки. Но этого не произойдет при изменении имени error.log, в этом случае, при необходимости, надо удалить временный файл analyze_nginx_logs_lastline. Если произойдет обнуление самого лога ( ротация лога ) , скрипт об этом сообщит.<br/>
Использование:<br/>
<br/>
Usage: analyze_nginx_logs.sh --nginx_log_name FILENAME --nginx_error_log_name FILENAME --number_top_ip X --number_top_pages Y --email E-MAIL<br/>
nginx_log_name - nginx file log name for parse<br/>
nginx_error_log_name - nginx error file log name for parse<br/>
number_top_ip - number of top request ip to print<br/>
number_top_pages - number of top request pages to print<br/>
email - email to send info<br/>
deafult nginx_log_name /var/log/nginx/access.log<br/>
deafult nginx_error_log_name /var/log/nginx/error.log<br/>
deafult number_top_ip 10<br/>
deafult number_top_pages 10<br/>
deafult email root@localhost<br/>
Examples: ./analyze_nginx_logs.sh --nginx_log_name zabbix.access.log --nginx_error_log_name error.log<br/>
--------- ./analyze_nginx_logs.sh --nginx_log_name /var/log/nginx/access.log --nginx_error_log_name /var/log/nginx/error.log --number_top_ip 20 --number_top_pages 20 --email root@localhost<br/>
<br/>
Для запуска скрипта также используется утилита sendmail, которую необходимо предварительно поставить. <br/>
<br/>
Пример для крона: <br/>
0 * * * * root cd /root && ./analyze_nginx_logs.sh  --nginx_log_name /var/log/nginx/zabbix.access.log --nginx_error_log_name /var/log/nginx/error.log <br/>
<br/>
<br/>
Примеры использования:<br/>

![Example run 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex04/exmple1.PNG)

![Example run 2](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex04/exmple2.PNG)

![Example run 3](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex04/exmple3.PNG)

![Example run 4](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex04/exmple4.PNG)


Домашнее задание <br/>
Пишем скрипт<br/>
Цель: В результате этого ДЗ вы научитесь писать простые скрипты, решающие нужные задачи, такие как мониторинг кол-ва ошибок в логах <br/> Освоите работу с файлами, поиском, парсингом текста, управлением блокировками<br/> 
написать скрипт для крона<br/>
который раз в час присылает на заданную почту<br/> 
- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта<br/> 
- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта<br/> 
- все ошибки c момента последнего запуска<br/> 
- список всех кодов возврата с указанием их кол-ва с момента последнего запуска<br/> 
в письме должно быть прописан обрабатываемый временной диапазон<br/> 
должна быть реализована защита от мультизапуска<br/> 
Критерии оценки:<br/> 
трапы и функции, а также sed и find +1 балл <br/> 
