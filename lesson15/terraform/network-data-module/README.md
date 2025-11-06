# Модуль Network Data

## Описание

Модуль "network-data" предназначен для получения информации о всех подсетях (subnet) в выбранной Virtual Private Cloud (VPC) в Yandex Cloud.

## Функционал

Модуль выполняет следующие операции:

- Получает информацию о выбранной VPC по ID
- Получает полный список всех подсетей в VPC
- Отображает детальную информацию о каждой подсети:
  - ID, имя подсети
  - Зона доступности (zone)
  - CIDR блоки (IPv4)
  - Таблица маршрутизации (если назначена)
  - Время создания
  - ID сети VPC



## Переменные
`folder_id`  -  ID каталога в Yandex Cloud
`vpc_id` - ID VPC для получения информации о подсетях
`default_zone`  - Зона по умолчанию (default: `ru-central1-a`)

## Выходные данные
`vpc_id`  - ID VPC
`vpc_name`  - Имя VPC
`all_subnets` - Полная информация о всех подсетях
`subnets_count`  - Количество подсетей в VPC 
`zones`  - Список всех зон с подсетями

## Аутентификация
нужно скопировать ключ сервисного аккаунта в корневую директорию проекта и не менять имя файла
"${path.module}/../key.json"

## Использование

### 1. Инициализация модуля
terraform init

### 2. Настройка переменных
Отредактируйте файл `terraform.tfvars`:
folder_id = "xxxxxxxxxxxx"
vpc_id = "xxxxxxxxxxxxx"
default_zone = "ru-central1-a"

### 3. Проверка плана
terraform plan

### 4. Применение конфигурации
terraform apply

### 5. Получение выходных данных
Все подсети
terraform output all_subnets

Список зон
terraform output zones

Количество подсетей
terraform output subnets_count


