#!/usr/bin/env bash
ip link add name br0 type bridge
ip link set dev br0 up
ip address add 10.0.0.200/24 dev br0
ip route append default via 10.0.0.1 dev br0
ip link set enp6s0 master br0
ip address del 10.0.0.200/24 dev enp6s0





# 3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
#     link/ether 50:eb:f6:80:bf:b6 brd ff:ff:ff:ff:ff:ff
#     inet 10.0.0.200/24 brd 10.0.0.255 scope global dynamic noprefixroute enp6s0
#        valid_lft 82151sec preferred_lft 82151sec
#     inet6 fd8a:d32f:bd5e:b240:4412:40c6:65b1:b211/64 scope global dynamic noprefixroute 
#        valid_lft 1784sec preferred_lft 1784sec
#     inet6 fe80::697c:dc95:89b2:25cc/64 scope link noprefixroute 
#        valid_lft forever preferred_lft forever
