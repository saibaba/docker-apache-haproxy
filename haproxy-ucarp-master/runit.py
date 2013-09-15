from  fabric.api import run, local, settings

login = '%s@%s' % ("root", "localhost")

with settings(host_string=login, port=49196, password='ubuntu'):
    run("/usr/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg")
    run("/usr/sbin/ucarp --interface=eth1 --srcip=192.168.200.4 --addr=192.168.200.1 --vhid=1 --pass=secret -B")


