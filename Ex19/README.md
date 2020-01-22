# LDAP. Централизованная авторизация и аутентификация.  

```
LDAP
1. Установить FreeIPA
2. Написать playbook для конфигурации клиента
3*. Настроить авторизацию по ssh-ключам

В git - результирующий playbook 
```

## В процессе сделано:

- Сделан Vagrant file и ansible плейбуки, разворачивающие готовый стенд с FreeIPA с авторизацией по ssh ключам. 
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex19/screenshots/hosts.PNG) <br/><br/>
 ![Image 2](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex19/screenshots/key.PNG) <br/><br/>
 ![Image 3](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex19/screenshots/ssh_check.PNG) <br/><br/>



## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex19 && vagrant up

## Как проверить работоспособность:
 - После отработки vagrant up ( может делть довольно долго ), необходимо в /etc/hosts на хотсе добавить запись 192.168.100.10 server.test.local 
 - Можно перейти по ссылке https://server.test.local/ipa/ui/  ( user admin ; password  123qweQWE) и проверить статус FreeIPA: хосты, юзеры, ключи
 - В директории Ex19 выполнить chmod 0600 appuser ; chmod 0600 appuser.pub; ssh -o "StrictHostKeyChecking no"  -i appuser appuser@192.168.100.11 
 - В результате должны попасть без вода пароля на сервер client1.test.local
<br>

---
