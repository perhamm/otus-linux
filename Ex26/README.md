# Web сервера.  

```
Простая защита от DDOS
Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.
Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

Смысл: умные боты попадаются редко, тупые боты по редиректам с куками два раза не пойдут

Для выполнения ДЗ понадобятся
https://nginx.org/ru/docs/http/ngx_http_rewrite_module.html
https://nginx.org/ru/docs/http/ngx_http_headers_module.html 
```

## В процессе сделано:
- Сделан vagrantfile, разворачивающий машину с nginx с дефалтовой страничкой, но с добавлением указонного в ДЗ конфига.
Реализовал конфиг вот так:
```
        location / {
          if ($cookie_access != "a64e9b3f-baba-4dca-936c-ac2cb6800cec") {
          rewrite ^(.*)$ http://192.168.100.10/set_access_cookie?url=$request_uri redirect;
          }
        }

        location ~* ^/set_access_cookie.*$ {
          add_header "Set-Cookie" "access=a64e9b3f-baba-4dca-936c-ac2cb6800cec";
          if ($arg_url  != "") {
            rewrite ^(.*)$ http://192.168.100.10$arg_url? redirect;
          }
          rewrite ^(.*)$ http://192.168.100.10 redirect;
        }

```
- В конфиге проверяется наличие cookie access, если нет или не соответствует - редиректим на location, где устанавливается cookie, при это сохраняем в аргументе url изначальный URI запроса.
- При переходе в location, где устанавливается cookie - добавляем  access=id, а также проверяем наличие аргумента url, если есть - редиректим по этому url, если нет - редиректим в корень.
<br/><br/>
 ![Image 1](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex26/screenshots/1.PNG) <br/><br/>
<br/><br/>
 ![Image 2](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex26/screenshots/2.PNG) <br/><br/>
 <br/><br/>
 ![Image 3](https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex26/screenshots/3.PNG) <br/><br/>

## Как запустить:
 - git clone https://github.com/perhamm/otus-linux && cd otus-linux/Ex26 && vagrant up

## Как проверить работоспособность:
 - Перейти по адресу http://192.168.100.10 с открытой вкладкой Network в консолью отладки. Должны появится редиректы. Должна установится кука access ( вкладка Storage у Firefox ). При установленной куке - редиректы отсутсвуют. При редиректах сохраняется изначальный адрес.
<br>

---
