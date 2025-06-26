FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    mysql-server \
    zabbix-server-mysql \
    zabbix-frontend-php \
    apache2 \
    php php-mysql php-gd php-xml php-bcmath php-mbstring \
    supervisor zcat net-tools && \
    apt clean

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 10051

CMD ["/entrypoint.sh"]
