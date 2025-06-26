#!/bin/bash

service mysql start

mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS 'zabbix'@'localhost' IDENTIFIED BY 'zabbix';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
EOF

zcat /usr/share/doc/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -pzabbix zabbix

# Remove flag após importação de funções
mysql -uroot -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# Insere senha do banco no config do servidor
sed -i 's/^#\?DBPassword=.*/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

# Inicia serviços via systemd (se suportado) e habilita na inicialização
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

# Inicia supervisord 
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
