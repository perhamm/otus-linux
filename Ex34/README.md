# Динамический веб контент.  

```
Vagrant стенд для NFS или SAMBA
NFS или SAMBA на выбор:

vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервер должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте (fstab или autofs)
в шаре должна быть папка upload с правами на запись
- требования для NFS: NFSv3 по UDP, включенный firewall
```

## В процессе сделано:
- Настроил Vagrantfile и плейбук ansible для развертки виртуальных машин server и client. На сервере включен firewall, и экспортируется папка /mnt/upload для клиента.
```
[root@client ~]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Sat Jun  1 17:13:31 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=8ac075e3-1124-4bb6-bef7-a6811bf8b870 /                       xfs     defaults        0 0
/swapfile none swap defaults 0 0
192.168.100.20:/mnt/upload /mnt nfs rw,vers=3,proto=udp,timeo=600 0 0
[root@client ~]# mount | grep mnt
192.168.100.20:/mnt/upload on /mnt type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=600,retrans=3,sec=sys,mountaddr=192.168.100.20,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.100.20)
[root@client ~]# touch  /mnt/111112323
[root@client ~]# ll /mnt
total 0
-rw-r--r--. 1 nfsnobody nfsnobody 0 Jan 31 22:22 1111
-rw-r--r--. 1 nfsnobody nfsnobody 0 Jan 31 22:23 111112323

```
## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex34 && vagrant up

## Как проверить работоспособность:
 - В клиенте подмонтирована папка /mnt/upload в точку /mnt по протоколу udp
 - На сервере включен firewalld

---
