# базовый образ debian:11
FROM debian:11

# установка nginx
RUN apt-get update && \
    apt-get install -y nginx

# создание папки
RUN mkdir -p /opt/www

# файл index.html
COPY index.html /opt/www/index.html

# конфиг nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открыть порт для nginx
EXPOSE 80

# запуск через Entrypoint
ENTRYPOINT ["nginx", "-g", "daemon off;"]
