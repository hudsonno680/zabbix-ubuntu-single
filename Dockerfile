FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências básicas
RUN apt update && apt install -y wget gnupg lsb-release

# Adiciona repositório do Zabbix para Ubuntu 22.04 (compatível)
RUN wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu22.04_all.deb && \
    dpkg -i zabbix-release_7.0-1+ubuntu22.04_all.deb && \
    apt update

# Instala componentes Zabbix e serviços
RUN apt install -y \
    mysql-server \
    zabbix-server-mysql \
    zabbix-frontend-php \
    apache2 \
    php php-mysql php-gd php-xml php-bcmath php-mbstring \
    supervisor net-tools && \
    apt clean

# Copia configs e scripts
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 10051

CMD ["/entrypoint.sh"]
