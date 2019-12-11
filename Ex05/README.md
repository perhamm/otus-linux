Постарался реальзовать все срипты. Отдельно по заданиям:
1) psax.sh - Вывод скрипта получился очень похожим на ps ax. Пример вывода ниже.
2) lsof.sh - Реализовал только функциональность по дескрипторам, не стал делать вывод отображения памяти и файлов ( mapping ), реализовал проверку сокетов на вхождение в /proc/net/[tcp|udp|tcp6|udp6|unix] , и если вхождение найдено - пишем об этом в предпосленюю колонку. Пример вывода ниже.
3) Обработчики добавил для двух последних скриптов - при сигнале завершения произвести очистку, плюс защита от мультизапуска.
4) ionice.sh - Необходимо изменить шедуллер на девайсе, с которого запускается скрипт, на cfq, поскольку только для cfq будет отрабатывать ionice приоритет ( echo "cfq" > /sys/block/sda/queue/scheduler ). Также лучше запускать скрипт на девайсе без LVM. Cкрипт сгенерирует достаточно объемный файлик - 10 Гигов, и запустит два процесса dd с разными ionice, читающими данный файлик. Пример вывода ниже.
5) сpunice.sh - Предваритльено необходимо запустить на всех ядрах системы любую задачу, иначе очень маленькая разница будет или её не будет вовсе. Скрипт запускает 4 процесса, каждая пара из которых запущены с определенными приоритетами, первый из пары это dd, берущий поток из /dev/urandom, второй это упаковщик gzip. Время мерятется на основе времени выполнения - и первая пара и вторая пара должны сгенерировать  и сжать 64M*5 данных. Пример вывода ниже


Пример вывода скриптов: 

1)

![psax - оригинал](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex05/psax1.PNG)
![psax - мой срипт](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex05/psax2.PNG)

2)

![lsof - пример вывода](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex05/lsof_part1.PNG)
![lsof - пример вывода](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex05/lsof_part2.PNG)

3)  Если прервать любой из скриптов 4 или 5, будет произведена очистка от временных файлов.

4)

![ionice - пример вывода](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex05/ionice.PNG)

5)

![cpunice - подготовка](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex05/cpu_prepare.PNG)
![cpunice - пример вывода](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex05/cpu_rez.PNG)

...

Домашнее задание
работаем с процессами
Цель: В результате ДЗ вы разберетесь что находится в файловой системе /proc и закрепите навыки работы с bash. Зачастую, например в контейнерах, у вас нет кучу удобных утилит предоставляющих информацию о процессах, ip адресах, итд И есть только один инструмент bash и /proc
Задания на выбор
1) написать свою реализацию ps ax используя анализ /proc
- Результат ДЗ - рабочий скрипт который можно запустить
2) написать свою реализацию lsof
- Результат ДЗ - рабочий скрипт который можно запустить
3) дописать обработчики сигналов в прилагаемом скрипте, оттестировать, приложить сам скрипт, инструкции по использованию
- Результат ДЗ - рабочий скрипт который можно запустить + инструкция по использованию и лог консоли
4) реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice
- Результат ДЗ - скрипт запускающий 2 процесса с разными ionice, замеряющий время выполнения и лог консоли
5) реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
- Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли
Критерии оценки: 5 баллов - принято - любой скрипт
+1 балл - больше одного скрипта
+2 балла все скрипты