# Mysql 

```
mysql cluster
развернуть InnoDB кластер в docker

в качестве ДЗ принимается репозиторий с docker-compose
который по кнопке разворачивает кластер и выдает порт наружу
```

## В процессе сделано:
- Сделан кастомный образ, запускающий скрипт mysql-shell/run.sh и впадающий в sleep. Докерфайл приложен. Скрипт запускает переданные ему в параметрах js/sql, либо просто запускает переданные комманды.
- Сделан docker-compose
- В docker-compose создаются 3 контейнера с mysql, запускается mysql-shell и обрабатываются скрипты из папки /innodb-cluster/scripts, потом запускается mysql-router




## Как запустить:
 - ``` cd otus-linux/Ex29/innodb-cluster/; docker-compose up -d   ```

## Как проверить работоспособность:
 - ``` docker logs -f innodb-cluster_mysql-shell_1 ```
 - Должно появится сообщение о окончании процесса установки :)
 - ```docker exec -ti innodb-cluster_mysql-shell_1  /bin/bash```
 - В контейнере запустиь
   -  ``` mysqlsh -h mysql-router -P 6447 --password="mysql" ```
   -  ```dba.getCluster().status();``` - должен показать статус
   -  ``` \sql ``` - переключаемся на sql
   -  ```SELECT * FROM test.test;``` - должен показать табличку
   -  В новом окне стопим докер контейнеры
      -  ```docker stop innodb-cluster_mysql-server-1_1```
      -  ```docker stop innodb-cluster_mysql-server-2_1```
   - В старом окне с shell sql ```SELECT * FROM test.test;``` - должен показать табличку, автоматически перезапустив shell
 - ```docker-compose down```

Немного скринов:
 - после установки статус
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex29/screenshots/1.PNG) <br/><br/>
  - стопаем два контейнера
<br/><br/>
 ![Image 2](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex29/screenshots/2.PNG) <br/><br/>
  - статус полсе остановки двух контейнеров, также добавляем запись
<br/><br/>
 ![Image 3](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex29/screenshots/4.PNG) <br/><br/>
  -стартуем два остановленных контейнера, стопаем оставшийся ранее контейнер
<br/><br/>
 ![Image 4](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex29/screenshots/6.PNG) <br/><br/>
 <br/><br/>
 ![Image 5](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex29/screenshots/5.PNG) <br/><br/>
---
