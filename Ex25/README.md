#  Мосты, туннели и VPN.  

```
VPN
1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку 
```

## В процессе сделано:

- Сделан Vagrantfile и ansible плейбуки, раворачиваюшие 3 сервера. 
- server1 - используется для подключения с хостовой машины к внутренним ресурсам этого сервера через файл конфигурации и ключи, лежащие в папке openvpn-server1/client (```sudo /usr/sbin/openvpn --config client01.ovpn```)
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex25/screenshots/host-server1-openvpn.png) <br/><br/>
- server2 и client соединены между собой тунелем, и нужны для тестрирования скорости соединения по tun/tap tcp/udp.
Тестирование показало, что наибольшей скоростью обладает конфигурация c udp / tun 
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex25/screenshots/tun-speed.png) <br/><br/>

## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex25 && vagrant up

## Как проверить работоспособность:
 - После отработки vagrant up перейти в папку Ex25/openvpn-server1/client
 - Выполнить ```sudo /usr/sbin/openvpn --config client01.ovpn```
 - В другом окне попробовать пиговать внутренний ip сервера server1: ```ping 172.20.200.1``` - пинг должен проходить
 - Проверить поднятый интерфейс tun0 на серверах server2 и client. Пинги должны проходить с клиента до сервера2 (```ping 172.20.245.1```)
 <br/><br/>


---
