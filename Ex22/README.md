# DNS/DHCP - настройка и обслуживание.   

```
настраиваем split-dns
взять стенд https://github.com/erlong15/vagrant-bind
добавить еще один сервер client2
завести в зоне dns.lab
имена
web1 - смотрит на клиент1
web2 смотрит на клиент2

завести еще одну зону newdns.lab
завести в ней запись
www - смотрит на обоих клиентов

настроить split-dns
клиент1 - видит обе зоны, но в зоне dns.lab только web1

клиент2 видит только dns.lab

*) настроить все без выключения selinux   
```

## В процессе сделано:

- Изменил в https://github.com/erlong15/vagrant-bind Vagrantfile и поправил ansible playbook для поддержки selinux и split dns. Очень намучался с тем, чтобы split зоны правильно уходили на slave сервер ( приходила одна зона - которая шла первой по порядку, не смотря на то, что файлы зон разные), реализовал по официальной доке с помощью разных ключей на трансфер зоны:
```
acl "client1" {192.168.50.15; key client1-view; };
acl "client2" {192.168.50.16; key client2-view; };
...
view "client1" {
    match-clients {"client1"; };
    allow-transfer { key client1-view; };
...
view "client2" {
    match-clients {"client2"; };
    allow-transfer { key client2-view; };
```

## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex22 && vagrant up

## Как проверить работоспособность:
 - После отработки vagrant up повыполнять dns запросы на client и client2.
```
nslookup dns.lab 192.168.50.10
nslookup dns.lab 192.168.50.11
nslookup web1.dns.lab 192.168.50.10
nslookup web1.dns.lab 192.168.50.11
nslookup web2.dns.lab 192.168.50.10
nslookup web2.dns.lab 192.168.50.11
nslookup newdns.lab 192.168.50.10
nslookup newdns.lab 192.168.50.11
nslookup www.newdns.lab 192.168.50.10
nslookup www.newdns.lab 192.168.50.11
```
Для client:
```
[vagrant@client ~]$ nslookup dns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

Name:	dns.lab
Address: 192.168.50.11
Name:	dns.lab
Address: 192.168.50.10

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup web1.dns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

Name:	web1.dns.lab
Address: 192.168.50.15

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup web1.dns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

Name:	web1.dns.lab
Address: 192.168.50.15

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup web2.dns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

** server can't find web2.dns.lab: NXDOMAIN

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup web2.dns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

** server can't find web2.dns.lab: NXDOMAIN

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup newdns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

Name:	newdns.lab
Address: 192.168.50.11
Name:	newdns.lab
Address: 192.168.50.10

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup newdns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

Name:	newdns.lab
Address: 192.168.50.10
Name:	newdns.lab
Address: 192.168.50.11

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup www.newdns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

Name:	www.newdns.lab
Address: 192.168.50.16
Name:	www.newdns.lab
Address: 192.168.50.15

[vagrant@client ~]$ 
[vagrant@client ~]$ nslookup www.newdns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

Name:	www.newdns.lab
Address: 192.168.50.16
Name:	www.newdns.lab
Address: 192.168.50.15

```
Для client2:
```
[root@client2 ~]# nslookup dns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

Name:	dns.lab
Address: 192.168.50.10
Name:	dns.lab
Address: 192.168.50.11

[root@client2 ~]# 
[root@client2 ~]# nslookup dns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

Name:	dns.lab
Address: 192.168.50.10
Name:	dns.lab
Address: 192.168.50.11

[root@client2 ~]# 
[root@client2 ~]# nslookup web1.dns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

Name:	web1.dns.lab
Address: 192.168.50.15

[root@client2 ~]# 
[root@client2 ~]# nslookup web1.dns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

Name:	web1.dns.lab
Address: 192.168.50.15

[root@client2 ~]# 
[root@client2 ~]# nslookup web2.dns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

Name:	web2.dns.lab
Address: 192.168.50.16

[root@client2 ~]# 
[root@client2 ~]# nslookup web2.dns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

Name:	web2.dns.lab
Address: 192.168.50.16

[root@client2 ~]# 
[root@client2 ~]# nslookup newdns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

** server can't find newdns.lab: NXDOMAIN

[root@client2 ~]# 
[root@client2 ~]# nslookup newdns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

** server can't find newdns.lab: NXDOMAIN

[root@client2 ~]# 
[root@client2 ~]# nslookup www.newdns.lab 192.168.50.10
Server:		192.168.50.10
Address:	192.168.50.10#53

** server can't find www.newdns.lab: NXDOMAIN

[root@client2 ~]# 
[root@client2 ~]# nslookup www.newdns.lab 192.168.50.11
Server:		192.168.50.11
Address:	192.168.50.11#53

** server can't find www.newdns.lab: NXDOMAIN

```
 - Проверить присутсвие файлов зон в /etc/named для сервера ns02
 <br/><br/>


---
