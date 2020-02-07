#  Проект на тему: "Откзоустойчивое хранилище файлов Seafile, интегрирвоанное с Ceph S3".  


## Общее описание


Seafile это web-приложение для размещения файлов с открытым исходным кодом. Файлы хранятся на центральном сервере и могут быть синхронизированы с персональными компьютерами и мобильными устройствами через web-интерфейс, либо по протоколу WebDav.
В качестве конечного хранилища файлов может быть использовано Ceph S3-api, причем есть возможность использовать пути вместо dns имен баскетов( path style)
Для организации высокой доступности производятся следующие дейтсвия:
- настраивается galera cluster (mariaddb 10.3, wsrep - rsync) с общим плавающим ip и haproxy на каждой ноде
- настраиватеся кластер active - backup memchached - просто два standalone сервера memchached с общим плавающим ip
- настраиватся ceph на 3 нодах с ролью rgw
- настраивается два сервера seafile в режиме кластера, в настройках указываются плавающий адрес galera, плавающий адрес ceph rgw
- создаются три баскета под хранилище seafile в ceph
- создаются два балансироващика с плавающим ip  и haprox для доступа клиентов

Схема получившегося стенда:

 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex18/screenshots/1.PNG)



## Как запустить:
- Необходимо скачать дистрибутив seafile seafile-pro-server_7.0.13_x86-64.tar.gz и положить в папку otus-linux/!Project/roles/seafile/files 
- Скачать дистрибутив seafile можно, например, отсюда: https://yadi.sk/d/afriqk7mdaBcrw
- Если требуется запустить vagrant ( ВНИМАНИЕ! НУЖНО МНОГО ПАМЯТИ! ) то просто vagrant up. Предварительно нужно установить pip и ansible версии 2.8.8 (```pip install ansible==2.8.8```)
- Если требуется запустить на виртуальных машинах( например proxmox ) - надо сделать инвентори ( пример в inventory-proxmox ) и выполнить последовательно 
```
cd otus-linux/\!Project/
ansible-playbook -i inventory-proxmox cluster.yml
cd otus-linux/\!Project/roles/ceph-ansible/
ansible-playbook -i ../../inventory-proxmox  --extra-vars "@./group_vars/all.yml" site.yml
cd otus-linux/\!Project/
ansible-playbook -i inventory-proxmox seafile.yml
```
Предварительно нужно установить pip и ansible версии 2.8.8.
Машины необходимо предсоздать со следующими параметрами:

Также необходима машина для интернета в vlan 3065 с адресом 192.168.65.254 и включенным dns  worward. Её надо будет указывать в качестве DG, с неё же можно разворачивать плейбуки.
 ![Image 2](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex18/screenshots/2.PNG)


## Как проверить
- http://192.168.62.100/  admin@seafile.local  123qweQWE
---
