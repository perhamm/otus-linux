
Домашнее задание <br/>
PAM<br/>
1. Запретить всем пользователям, кроме группы admin логин в выходные(суббота и воскресенье), без учета праздников<br/>
2. Дать конкретному пользователю права рута <br/>

В Vagrantfile встроено выполенние ansible плайбука playbook.yml. <br/>
После запуска vagrant up можно войти пользователем vagrant ( vagrant ssh ).<br/>
Пользователем user1 или user2 - только если на хосте не выходной день(ssh user1@192.168.11.101 пароль 123qweQWE)<br/>
Пользователем admin (пароль 123qweQWE)<br/>
При этом пользователь admin имеет полные права на исполнение любой комманды ( sudo -i ).<br/>
user1 и user2 не входят в группу admin, пользователь admin входит в группу admin, для группы admin разрешен вход в любой день, а также полные sudo права. Пользователям, не входящим в группу admin, кроме пользователя vagrant, запрещен вход в выходной день.<br/>

Для проверки скрипа проще всего в playbook.yml дать номера day_of_the_week_1 и day_of_the_week_2 дней недели, соответствующих сегодняшнему дню и следующему за ним. Например, если сегодня среда, то day_of_the_week_1: 3 и day_of_the_week_1: 4 В этом случае будет запрещен вход поьзователям user1 и user2<br/>
Плейбук копирует срипт test_login.sh по пути /usr/local/bin/test_login.sh и добавляет account required pam_exec.so /usr/local/bin/test_login.sh в /etc/pam.d/sshd<br/>
Скрипт проверяет выходной ли сегодня день и входит ли пользователь в группу admin, на основании чего возвращает 0 или 1.
