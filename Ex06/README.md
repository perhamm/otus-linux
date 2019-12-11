Все дейтсвия проводил на CentOS 7, в том числе тестирование пакетов в репозитории :) Добавил в nginx часто используемый нами ( и похоже только нами :) ) модуль для керберос авторизации https://github.com/stnoonan/spnego-http-auth-nginx-module 

Для этого скачал source rpm nginx-1.16.1-1 ( yumdownloader --source nginx ). Далее распокавал rpm ( rpm -ihv nginx-1.16.1-1.el7.src.rpm ) и изменил архив rpmbuild/SOURCES/nginx-1.16.1.tar.gz, добавив в него папку spnego-http-auth-nginx-module.
В spec файл внес простое измение --add-module=spnego-http-auth-nginx-module \ 

Далее все это собрал  ( rpmbuild -ba rpmbuild/SPECS/nginx.spec  ) и закинул на виртуалку с веб-сервером в AWS

Репозиторий доступ по адресу http://ec2-18-184-142-43.eu-central-1.compute.amazonaws.com/repo/

Необходимо закинуть  файлик репозитория https://raw.githubusercontent.com/perhamm/otus-linux/master/Ex06/otus.repo в папку /etc/yum.repos.d/ , и , если есть другие репозитории с пакетами nginx, исключить установку из них nginx*, например, для epel.repo добавить в конец строчку exclude=nginx*

	[root@vds01-tioesi-35 otus-linux]# cat /etc/yum.repos.d/epel.repo 
	[epel]
	name=Extra Packages for Enterprise Linux 7 - $basearch
	#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
	metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
	failovermethod=priority
	enabled=1
	gpgcheck=1
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
	exclude=nginx*



После этого можно установить nginx: yum install nginx -y

Проверить установку можно, выполнив nginx -V: в строке опций будет --add-module=spnego-http-auth-nginx-module.Также можно добавить auth-gss on; в какой-нибудь блок location. Если поставилось неправильно, то nginx -t выведет, что не знает что такое auth_gss.

	[root@vds01-tioesi-35 otus-linux]# nginx -V
	nginx version: nginx/1.16.1
	built by gcc 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC) 
	built with OpenSSL 1.0.2k-fips  26 Jan 2017
	TLS SNI support enabled
	configure arguments: --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --pid-path=/run/nginx.pid --lock-path=/run/lock/subsys/nginx --user=nginx --group=nginx --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-stream_ssl_preread_module --with-http_addition_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-http_perl_module=dynamic --with-http_auth_request_module --with-mail=dynamic --with-mail_ssl_module --with-pcre --with-pcre-jit --with-stream=dynamic --with-stream_ssl_module --with-google_perftools_module --with-debug --add-module=spnego-http-auth-nginx-module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic' --with-ld-opt='-Wl,-z,relro -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -Wl,-E'


Также для выполнения задания со * сделал Dockerfile ( в папке nginx_build_docker ), который собирает nginx и меняет стартовую страничку.

Запуск docker run -d -p 80:80 perhamm/nginx-test

Ссылка на репо https://hub.docker.com/repository/docker/perhamm/nginx-test




###############

Домашнее задание
Размещаем свой RPM в своем репозитории
Цель: Часто в задачи администратора входит не только установка пакетов, но и сборка и поддержка собственного репозитория. Этим и займемся в ДЗ.
1) создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
2) создать свой репо и разместить там свой RPM
реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо

* реализовать дополнительно пакет через docker
Критерии оценки: 5 - есть репо и рпм
+1 - сделан еще и докер образ 
