Apache site with haproxy on docker
----------------------------------

1. cd apache
2. docker build sai/apache1 .
3. edit site/index.html and change PRIMARY to SECONDARY
4. docker build sai/apache2 .
5. cd ../haproxy
6. docker build sai/haproxy .
7. ./bare.sh

Running multiple commands in docker
-----------------------------------

1. Run sshd in docker
2. NAT port 22 on the host
3. run commands remotely in container using fabric (see example in haproxy-ucarp-master/runit.py)

HA for haproxy
--------------

As it stands, there is a problem with above set up. if container hostling haproxy is down, the apache servers are not reachable. We can run a another container with haproxy in stand-by mode. We can use UCARP to provide this feature. Here are the steps.

1. cd haproxy-ucarp-master
2. docker build sai/haproxy-ucarp-master .   [ It was built from sai/haproxy, with adding apt entry for ucarp and then using it as base, currently it references FROM haproxy-ucarp-master as I was playing with it adding more stuff]
3. cd ..
4. APACHE1=(docker run -d sai/apache1)
5. APACHE2=(docker run -d sai/apache2) [ ideally it will be apache1 but, to visibly see that the response coming from two different apache servers, I edited index.html]
6. ./pipework.sh br0apache $APACHE1 192.168.200.2
7. ./pipework.sh br0apache $APACHE2 192.168.200.3
8. HA1=(docker run -d  -p 10001 -p 22  sai/haproxy-ucarp-master /usr/sbin/sshd -D)
9. HA2=(docker run -d  -p 10001 -p 22  sai/haproxy-ucarp-master /usr/sbin/sshd -D)
10. ../pipework.sh br0apache $HA1  192.168.200.4
11. ../pipework.sh br0apache $HA2  192.168.200.5
12. ifconfig br0apache 192.168.200.10 up [ here we are assiging an IP to bridge itself, make sure that this does not conflict with anything else on the host machine running containers - we use this to expose the active  ucarp instance outside the containers, via br0apache. We can use NAT on each of HA1 and HA2 and they will have different Port numbers and we need to some how make them available as a single IP/Port to outside the host with further NATting on host ]
13. ssh root@localhost -p <ssh port NATTED for HA1, from docker ps right most column> "/usr/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg"
14. ssh root@localhost -p <ssh port NATTED for HA1> "/usr/sbin/ucarp --interface=eth1 --srcip=192.168.200.4 --addr=192.168.200.1 --vhid=1 --pass=secret -b 1 --upscript=/etc/vip-up.sh --downscript=/etc/vip-down.sh -B -P" [-P will make it master immediately]
15. ssh root@localhost -p <ssh port NATTED for HA2> "/usr/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg"
16. ssh root@localhost -p <ssh port NATTED for HA2> "/usr/sbin/ucarp --interface=eth1 --srcip=192.168.200.5 --addr=192.168.200.1 --vhid=1 --pass=secret -b 1 --upscript=/etc/vip-up.sh --downscript=/etc/vip-down.sh -B"

There is no need to NAT 10001 as you are exposing the IP itself directly to the host via bridging containers with host with br0apache.

Notes
-----
You might have to add below line to /etc/apt/sources.list to be able to install ucarp:

deb http://ubuntu.mirror.cambrium.nl/ubuntu/ precise main universe

References
----------

* https://github.com/toscanini/maestro
* https://github.com/opdemand/deis
* http://docs.docker.io/en/latest/examples/running_ssh_service/
* http://www.tldp.org/HOWTO/Ethernet-Bridge-netfilter-HOWTO-3.html
* http://rbgeek.wordpress.com/2012/09/02/simple-failover-cluster-using-ucarp-on-ubuntu/


