#  Резервное копирование. 

Настроить стенд Vagrant с двумя виртуальными машинами server и client.

Настроить политику бэкапа директории /etc с клиента:
1) Полный бэкап - раз в день
2) Инкрементальный - каждые 10 минут
3) Дифференциальный - каждые 30 минут

Запустить систему на два часа. Для сдачи ДЗ приложить list jobs, list files jobid=<id>
и сами конфиги bacula-*

## В процессе сделано:
 - Создан Vagrant file, поднимающий bacula, baculum и клиента к ним. 
 - Настройка политики в соответствии с заданием.
 - Для удобства использования поднят baculum. Через него можно позапускать Job бэкапа, но Job восстановления - только через консоль.  
![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex14/screenshots/pic1.PNG)
![Image 2](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex14/screenshots/pic2.PNG)
 - Файлик с выводом команд и конфиги приложены ( list jobs and files.txt и bacula*.conf ).

<br>

## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex14 && vagrant up

## Как проверить работоспособность:
 - Перейти по адресу http://192.168.100.10:9095/ с хостовой машины ( admin / admin ) и позапускать Jobs или просто подождать и посмотреть Job history.

<br>

---
