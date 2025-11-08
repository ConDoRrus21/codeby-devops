# базовый образ alpine:latest
FROM alpine:latest

# Установка nginx
RUN apk add --no-cache nginx

# Создание папки
RUN mkdir -p /opt/www

# файл index.html
COPY index.html /opt/www/index.html

# конфиг nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открыть порт для nginx
EXPOSE 80

# Запуск через CMD
CMD ["nginx", "-g", "daemon off;"]
