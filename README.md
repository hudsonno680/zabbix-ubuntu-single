# Zabbix All-in-One (Ubuntu)

Este projeto cria um container único com MySQL, Zabbix Server 7.0 e frontend web(apache-php) baseado em Ubuntu 24.04.

Referência:

https://www.zabbix.com/download?zabbix=7.0&os_distribution=ubuntu&os_version=24.04&components=server_frontend_agent&db=mysql&ws=apache

## Como usar

```bash
docker build -t zabbix-ubuntu-single .
docker run -d --name zabbix-allinone -p 8080:8080 -p 10051:10051 zabbix-ubuntu-single
