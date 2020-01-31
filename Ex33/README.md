# Динамический веб контент.  

```
Собрать стенд с 3мя проектами на выбор
Варианты стенда
nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular)
nginx + java (tomcat/jetty/netty) + go + ruby
можно свои комбинации

Реализации на выбор
- на хостовой системе через конфиги в /etc
- деплой через docker-compose

Для усложнения можно попросить проекты у коллег с курсов по разработке

К сдаче примается
vagrant стэнд с проброшенными на локалхост портами
каждый порт на свой сайт
через нжинкс
```

## В процессе сделано:
- Настроил Vagrantfile и плейбук ansible для развертки следующей конфигурации:
  * проект https://github.com/perhamm/django-helloworld c django висит на порту localhost:8000 и проксирутся nginx с порта 83
  * проект https://github.com/geetarista/go-http-hello-world с go висит на порту localhost:8800 и проксирутся nginx с порта 81
  * проект https://github.com/perhamm/react-helloworld с react висит на порту localhost:7777 и проксирутся nginx с порта 82
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex33/screenshots/1.PNG) <br/><br/>


## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex33 && vagrant up

## Как проверить работоспособность:
 - Перейти по ссылкам http://192.168.100.20:83/ http://192.168.100.20:82 http://192.168.100.20:81 после деплоя

---
