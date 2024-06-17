# Начнем с базового образа Alpine
FROM caddy:2.8.4-builder AS builder

# Копируем и устанавливаем зависимости для wg-easy
COPY src /app
WORKDIR /app

# Устанавливаем зависимости
RUN npm install -g npm@latest && npm install

# Настраиваем порты для AdGuardHome
EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 853/tcp \
    853/udp 3000/tcp 3000/udp 5443/tcp 5443/udp 6060/tcp

# Настраиваем порты для wg-easy
EXPOSE 51820/udp 51821/tcp

# Установим переменные среды для wg-easy
ENV DEBUG=Server,WireGuard

# Запускаем оба сервиса через dumb-init
WORKDIR /opt/adguardhome/work

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/sh", "-c", "/opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work & cd /app/src && node server.js"]
