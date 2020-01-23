# Сетевые пакеты. VLAN'ы. LACP.  

```
строим бонды и вланы
В Office1 в тестовой подсети появляется сервер с доп. интерфесами и адресами в internal сети testLAN:
- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
- testServer2- 10.10.10.1

Изолировать с помощью vlan:
testClient1 <-> testServer1
testClient2 <-> testServer2

Между centralRouter и inetRouter создать 2 линка (общая inernal сеть) и объединить их с помощью bond-интерфейса,
проверить работу c отключением сетевых интерфейсов

Результат ДЗ: vagrant файл с требуемой конфигурацией
Конфигурация должна разворачиваться с помощью ansible

* реализовать teaming вместо bonding'а (проверить работу в active-active)
** реализовать работу интернета с test машин   
```

## В процессе сделано:

- Сделан Vagrant file и ansible плейбуки, раворачиваюшие машины cсогласно схеме.
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex24/screenshots/vlan.png) <br/><br/>
- Реализовал bond из двух интерфейсов eth1 и eth2 в одной internal сети на серверах inerRouter и centralRouter с параметрами mode=1 miimon=100 fail_over_mac=1. Проверил работу при отказе одного из линков:
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex24/screenshots/check_failover.PNG) <br/><br/>
 - Сделал одинаковую адресацию в разных vlan одной internal сети для машин test*. Для организации интернета на них поднял testRouter1 и testRouter2 с NAT. В итоге в одной сети имеем полностью работающие две связки client-server с одниковой адресацией и инетрнетом
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex24/screenshots/vlan-same-ip.PNG) <br/><br/>

## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex24 && vagrant up

## Как проверить работоспособность:
 - После отработки vagrant up проверить /proc/net/bonding/bond0 на inetRouter и centralRouter, можно попробовать поотключать интерфейсы.
 - Проверить интернет  и адресацию на test* машинах
 <br/><br/>


---
