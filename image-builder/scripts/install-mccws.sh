#!/bin/bash

cd /opt
git clone https://github.com/gtortone/mcc-ws.git

cp /opt/mcc-ws/supervisor/mcc-ws.conf /etc/supervisor/conf.d
