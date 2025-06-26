FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Instala dependências básicas e suporte a locale
RUN apt update && apt install -y wget gnupg lsb-release locales && \
    locale-gen en_US.UTF-8 pt_BR.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Adiciona repositório oficial do Zabbix 7.0 para Ubuntu 24.04
RUN wget -O /tmp/zabbix-release.deb https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-4+ubuntu24.04_all.deb && \
    dpkg -i /tmp/zabbix-release.deb && rm /tmp/zabbix-release.deb && \
    apt update

# Instala Zabbix, MySQL, Apache, PHP e utilitários
RUN apt install -y \
    mysql-server \
    zabbix-server-mysql \
    zabbix-frontend-php \
    zabbix-apache-conf \
    zabbix-sql-scripts \
    zabbix-agent \
    supervisor net-tools && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Copia configs e scripts
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 10051

CMD ["/entrypoint.sh"]
