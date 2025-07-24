#!/bin/bash

braddr=$(cat /proc/cmdline | sed -e 's/ /\n/g' | grep braddr | cut -d= -f2)
sed -i "s/^MACAddress=.*/MACAddress=$braddr/" /etc/systemd/network/br0.netdev
