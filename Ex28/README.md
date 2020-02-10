# Mysql 

```
развернуть базу из дампа и настроить репликацию
В материалах приложены ссылки на вагрант для репликации
и дамп базы bet.dmp
базу развернуть на мастере
и настроить чтобы реплицировались таблицы
| bookmaker |
| competition |
| market |
| odds |
| outcome

* Настроить GTID репликацию

варианты которые принимаются к сдаче
- рабочий вагрантафайл
- скрины или логи SHOW TABLES
* конфиги
* пример в логе изменения строки и появления строки на реплике 
```

## В процессе сделано:
- Сделал Vagrantfile и небольшие ansible плейбуки ( по методичке), реализующие  все условия.
Пример репликции таблицы:
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex28/screenshots/1.PNG) <br/><br/>
Пример в логе:
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex28/screenshots/2.PNG) <br/><br/>



## Как запустить:
 - vagrant up

## Как проверить работоспособность:
 - root пароль от базы находится в /home/vagrant/my.cnf
---
