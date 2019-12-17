По первой части - в папке nginx_build находится докерфайл, кастомные настройки и кастомная стартовая страничка. 
Образ, собранный из этого докер файла, запушен в perhamm/nginx (https://hub.docker.com/repository/docker/perhamm/nginx) 
Запуск: docker run -d -p 80:80 perhamm/nginx

Результат:

![nginx - пример вывода](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex15/nginx.PNG)

Ответы на вопросы: a) контейнер и образ это просто разные сущности, образ это исходник из файловых слоев, хранящихся в репозитории/на диске, и из него уже запускается контейнер в своих неймспейсах и ядром хоста, с rw слоем и ограниченный в ресурсах через cgroups. б) Собрать ядро можно в архив bzImage, поставив в контейнер необходимые для компиляции утилиты, но применить это ядро нельзя - uname -a  всегда будет выдавать в любом контейнере ядро хоста, да и вообще там загрузчика нет ))

По второй части - в папке docker-compose находится docker-compose.yml, через него запускаются два контейнера web и php из https://hub.docker.com/repository/docker/perhamm/nginx и https://hub.docker.com/repository/docker/perhamm/php-fpm, на 80 порту показывается php info. Желательно использовать полседнюю версию docker-compose для поддержки версии файла 3.7 ( ```curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
; chmod +x /usr/bin/docker-compose ```).

Результат docker-compose up -d:

![compose - пример вывода](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex15/compose.PNG)


---
ДЗ:

Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)Определите разницу между контейнером и образом. Вывод опишите в домашнем задании. Ответьте на вопрос: Можно ли в контейнере собрать ядро? Собранный образ необходимо запушить в docker hub и дать ссылку на ваш репозиторий.

Задание со * (звездочкой) Создайте кастомные образы nginx и php, объедините их в docker-compose. После запуска nginx должен показывать php info. Все собранные образы должны быть в docker hub.
