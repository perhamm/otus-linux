# Фильтрация трафика.  

```
Сценарии iptables
1) реализовать knocking port
- centralRouter может попасть на ssh inetrRouter через knock скрипт
пример в материалах
2) добавить inetRouter2, который виден(маршрутизируется) с хоста
3) запустить nginx на centralServer
4) пробросить 80й порт на inetRouter2 8080
5) дефолт в инет оставить через inetRouter  
```

## В процессе сделано:

- Сделан Vagrant file, раворачиваюший машины inetRouter, inetRouter2, centralRouter и centralServer. На centralServer разворачивается nginx на порту 80. На inetRouter - добавляются правила, запрещающие ssh коннекты по internal сети, но разрешается knocking последовательность 8881 7777 9991. Настраивается проброс порта 8080 хостовой машины на inetRouter2, и с него в свою очередь на nginx на порт 80. 
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex20/screenshots/iptables.png) <br/><br/>


## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex20 && vagrant up

## Как проверить работоспособность:
 - После отработки vagrant up можно проверить адрес http://127.0.0.1:8080/ - будет показываться nginx 
 - На centralRouter (```vagrant ssh centralRouter```) запусить от root (```sudo -i ```) скрипт knock.sh (```./knock.sh```). Должно провалится по ssh в inetRouter.
 <br/><br/>
 ![Image 2](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex20/screenshots/knock.PNG) <br/><br/>
<br>

---
