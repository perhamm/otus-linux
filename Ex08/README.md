

1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig.<br>
   Сделал скрипт watchlog.sh, который мониторит фразу в логе и пишет в стандартный вывод дебаг информацию, а также найденные фразы с момента последнего запуска в ``` /var/log/watchlog.log ``` Номер строки и дата последнего запуска записываются во временный файл. Скрипт запускается раз в 30 секунд с помощью сервис юнита watchlog.service и таймера к нему watchlog.timer. Фраза и лог в ```/etc/sysconfig/watchlog ``` <br>
![пример](https://github.com/perhamm/otus-linux/blob/master/Ex08/watch%20log.PNG)


2. Установить систему с LVM, после чего переименовать VG<br>
Делаем vgrename, после чего правим  /etc/fstab, /etc/default/grub, /boot/grub2/grub.cfg и перегенерируем initrd <br>
`mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)`<br>
[пример](https://yadi.sk/i/cxU1J-3IG2uweg)

3. Добавить модуль в initrd<br>
В /usr/lib/dracut/modules.d/01test кладем [module-setup.sh](https://gist.github.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85) и [test.sh](https://gist.github.com/lalbrekht/ac45d7a6c6856baea348e64fac43faf0), после чего пересобираем образ initrd <br>
[пример](https://yadi.sk/i/oVftP9Dc-iTlKQ)

4. Сконфигурировать систему без отдельного раздела с /boot, а только с LVM<br>
Добавляем новый диск, инициализируем с параметром --bootloaderareasize 1m, создаем новую дисковую группу и логический том, копируем на них систему, делаем chroot. Ставим пакет grub2 из указанного репозитория, пересобираем grub.cfg, правим  /etc/fstab, /etc/default/grub.<br>
[результат по заданию со *](https://yadi.sk/i/KvPCuAt_9qlCEA)
```
yum install xfsdump -y
yum install grub2
pvcreate /dev/sdb --bootloaderareasize 1m
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l +100%FREE /dev/vg_root
mkfs.xfs /dev/vg_root/lv_root
mount /dev/vg_root/lv_root /mnt
xfsdump -J - /dev/otus/root | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ ; do mount --bind $i /mnt/$i; done
cp -R /boot /mnt
chroot /mnt/
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
vi /etc/fstab 
vi /etc/default/grub 
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-install /dev/sdb
```

<br>
<br>
---
Домашнее задание
Systemd
Цель: Управление автозагрузкой сервисов происходит через systemd. Вместо cron'а тоже используется systemd. И много других возможностей. В ДЗ нужно написать свой systemd-unit.
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами
4*. Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл
Задание необходимо сделать с использованием Vagrantfile и proviosioner shell (или ansible, на Ваше усмотрение) 
