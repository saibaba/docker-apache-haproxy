FROM sai/haproxy-ucarp-master

MAINTAINER Saibaba Telukunta version: 0.1

RUN apt-get update && apt-get install -y haproxy && apt-get install -y ucarp && apt-get install -y opensshd-server

EXPOSE 80
EXPOSE 22

ADD ./haproxy.cfg /etc/haproxy/haproxy.cfg
ADD ./vip-up.sh /etc/vip-up.sh
ADD ./vip-down.sh /etc/vip-down.sh

#ENTRYPOINT ["/usr/sbin/haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
