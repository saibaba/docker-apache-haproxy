FROM ubuntu

MAINTAINER Saibaba Telukunta version: 0.1

RUN apt-get update && apt-get install -y haproxy

EXPOSE 80

ADD ./haproxy.cfg /etc/haproxy/haproxy.cfg
ENTRYPOINT ["/usr/sbin/haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
