# Zabbix All-in-One (Ubuntu)

Este projeto cria um container único com MySQL, Zabbix Server e frontend web baseado em Ubuntu 24.04.

## Como usar

```bash
docker build -t zabbix-ubuntu-single .
docker run -d --name zabbix-allinone -p 8080:80 -p 10051:10051 zabbix-ubuntu-single
