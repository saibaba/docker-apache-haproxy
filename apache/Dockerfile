FROM ubuntu

MAINTAINER Saibaba Telukunta version: 0.1

RUN apt-get update && apt-get install -y apache2

ADD ./site /var/www
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apach2

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
