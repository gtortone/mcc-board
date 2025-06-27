#!/bin/bash

braddr=$(cat /proc/cmdline | sed -e 's/ /\n/g' | grep braddr | cut -d= -f2)
ip link set dev br0 address $braddr
