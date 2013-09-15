Apache site with haproxy on docker
----------------------------------

1. cd apace
2. docker build sai/apache1 .
3. edit site/index.html and change PRIMARY to SECONDARY
4. docker build sai/apache2 .
5. cd ../haproxy
6. docker build sai/haproxy
7. ./bare.sh

Running multiple commands in docker
-----------------------------------

1. Run sshd in docker
2. NAT port 22 on the host
3. run commands remotely in container using fabric (see example in haproxy-ucarp-master/runit.py)

References
----------

* https://github.com/toscanini/maestro
* https://github.com/opdemand/deis
* http://docs.docker.io/en/latest/examples/running_ssh_service/

