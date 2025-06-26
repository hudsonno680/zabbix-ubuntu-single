#!/bin/bash

service mysql start

mysql -uroot <<EOF
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'zabbix';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
EOF

zcat /usr/share/doc/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -pzabbix zabbix

mysql -uroot <<EOF
mysql> set global log_bin_trust_function_creators = 0;
EOF

sed -i 's/^#\?DBPassword=.*/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2 

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
