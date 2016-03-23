#!/bin/sh
sed -ri "s/tom/$1/g" /etc/ppp/cron_ppp
ifconfig eth0 $2
/usr/sbin/squid -z &
/etc/ppp/cron_ppp &
/usr/bin/supervisord
