По всем пунктам ДЗ записал небольшие мини-видео.

1. Попасть в систему без пароля несколькими способами<br>
   Есть два принципиально разных способа -  использование параметра init и использование параметра rd.break. 
   - Способ 1. <br>
init=/bin/sh <br>
В конце строки начинающейся с linux16 добавляем init=/bin/sh и нажимаем сtrl-x для загрузки в систему<br>
[пример](https://yadi.sk/i/tPBgyCykIQ_LmA)
   - Способ 2. <br>
rd.break<br>
В конце строки начинающейся с linux16 добавляем rd.break и нажимаем сtrl-x для загрузки в систему.<br>
[пример](https://yadi.sk/i/jPuIOKjTcYJPzw)<br>
*Ключевое различие в том, что при использовании rd.break  мы входим в initrd  (rd - рам диск) до монтирования корневого раздела вызовом pivot_root(), при использовании же init=/bin/sh корневой раздел уже смонтирован.*

2. Установить систему с LVM, после чего переименовать VG<br>
Делаем vgrename, после чего правим  /etc/fstab, /etc/default/grub, /boot/grub2/grub.cfg и перегенерируем initrd <br>
`mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)`<br>
[пример](https://yadi.sk/i/cxU1J-3IG2uweg)

3. Добавить модуль в initrd<br>
В /usr/lib/dracut/modules.d/01test кладем [module-setup.sh](https://gist.github.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85) и [test.sh](https://gist.github.com/lalbrekht/ac45d7a6c6856baea348e64fac43faf0), после чего пересобираем образ initrd <br>
[пример](https://yadi.sk/i/oVftP9Dc-iTlKQ)

4. Сконфигурировать систему без отдельного раздела с /boot, а только с LVM<br>
Добавляем новый диск, инициализируем с параметром --bootloaderareasize 1m, создаем новую дисковую группу и логический том, копируем на них систему, делаем chroot. Ставим пакет grub2 из указанного репозитория, пересобираем grub.cfg, правим  /etc/fstab, /etc/default/grub.<br>
[результат по заданию со *](https://yadi.sk/i/tPBgyCykIQ_LmA)
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


<br><br><br>
---
Домашнее задание
Работа с загрузчиком
Цель: Зайти в систему без пароля рута - базовая задача сисадмина ( ну и одно из заданий на любой линуксовой сертификации). Так же нужно уметь управлять поведением загрузчика. Это и будем учиться делать в ДЗ
1. Попасть в систему без пароля несколькими способами
2. Установить систему с LVM, после чего переименовать VG
3. Добавить модуль в initrd

4(*). Сконфигурировать систему без отдельного раздела с /boot, а только с LVM
Репозиторий с пропатченым grub: https://yum.rumyantsev.com/centos/7/x86_64/
PV необходимо инициализировать с параметром --bootloaderareasize 1m
Критерии оценки: Описать действия, описать разницу между методами получения шелла в процессе загрузки.
Где получится - используем script, где не получается - словами или копипастой описываем действия. 
