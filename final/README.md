
Проект демонстрирует полный цикл разработки, развёртывания и мониторинга Java‑приложения `diplom-app` с использованием современных DevOps‑практик: CI/CD‑конвейеры, контейнеризация, система логирования (EFK) и мониторинга (Prometheus/Grafana).

---

## Устройство репозитория

```
codeby-devops/
├── final/
│   ├── diplom-app/                 # Исходники приложения
│   │   ├── src/main/java/
│   │   │   └── com/example/demoapp/
│   │   │       └── App.java        # приложение
│   │   ├── src/main/resources/
│   │   │   └── application.properties  Настройки Tomcat и логирования
│   │   ├── pom.xml                 # Maven конфигурация
│   │   └── Dockerfile              # Cборка Java приложения
│   │
│   ├── prometheus/                 # Конфигурация Prometheus
│   │   ├── prometheus.yml          # Targets для метрик
│   │   └── blackbox.yml            # Blackbox Exporter конфиг
│   │
│   ├── grafana/                    # Dashboards и Provisioning
│   │   ├── provisioning/
│   │   │   ├── datasources/        # Автопровизионирование источников
│   │   │   └── dashboards/         
│   │   └── dashboards/             # JSON dashboard
│   │
│   ├── fluentd/                    # Конфигурация логирования
│   │   ├── Dockerfile              # Fluentd образ с плагинами
│   │   └── fluent.conf             # Маршрутизация и парсинг логов
│   │
│   └── docker-compose.yml          # Оркестрация всех сервисов
│
├── .github/
│   └── workflows/
│       └── maven-ci-cd.yml         # CI/CD pipeline (GitHub Actions)
│
└── README.md                       # Документация проекта
```

### Ключевые компоненты

- **diplom-app**: само JAVA приложение. Представляет собой сервис, который выводит в браузере текст "my final app with CI flow"
- **GitHub Actions**: Автоматизированный конвейер сборки и публикации образов
- **Prometheus + Grafana**: Мониторинг метрик, контейнеров и приложения
- **Elasticsearch + Fluentd + Kibana**: Централизованная система логирования


---

## Развёртывание инфраструктуры

1. **Клонируй репозиторий и перейди в папку проекта:**

```bash
git clone https://github.com/ConDoRrus21/codeby-devops.git
cd codeby-devops/final
```

2. **Загрузи актуальный образ приложения из GHCR:**

```bash
docker compose pull diplom-app
```

3. **Разверни всю инфраструктуру:**

```bash
docker compose up -d
```

4. **Проверь статус контейнеров:**

```bash
docker compose ps
```

### Доступ к сервисам

| Сервис                | URL                      |
|-----------------------|--------------------------|
| **Приложение**        | `http://localhost:8082/` | 
| **Prometheus**        | `http://localhost:9090/` |
| **Blackbox Exporter** | `http://localhost:9115/` |
| **Grafana**           | `http://localhost:3000/` |
| **Kibana**            | `http://localhost:5601/` | 
| **cAdvisor**          | `http://localhost:8081/` |
| **Elasticsearch**     | `http://localhost:9200/` |


### Остановка инфраструктуры

```bash
docker compose down
```
### Очистка данных (включая volumes)

```bash
docker compose down -v
```

---

## Архитектура развёртывания

```
GitHub Repository
    ↓
Git Push → Branch: final
    ↓
GitHub Actions Trigger (maven-ci-cd.yml)
    ↓
[Build] Maven: mvn -B clean verify
    ↓
[Test] Maven: Unit тесты + SonarQube analyze (through service sonarcloud.io)
    ↓
[Build Image] Docker: Dockerfile → ghcr.io/condorrus21/codeby-devops:diplom-app-latest
    ↓
[Push] Docker Push → GitHub Container Registry (GHCR)
    ↓
Docker Compose Pull: docker compose pull diplom-app
    ↓
Container Runtime: Docker container (port 8082)
    ↓
Logging: Fluentd → Elasticsearch → Kibana
Monitoring: cAdvisor → Prometheus → Grafana
```

##  Правила внесения изменений в инфраструктуру

### Общий процесс

1. **Создай feature-ветку из главной**


2. **Внеси изменения:**
   - Изменения в коде приложения → `diplom-app/`
   - Изменения в Fluentd → `fluentd/fluent.conf` или `fluentd/Dockerfile`
   - Изменения в Prometheus → `prometheus/prometheus.yml`
   - Изменения в Grafana → `grafana/provisioning/` или `grafana/dashboards/`

3. **Протестируй локально:**

```bash
# Перестройка сервиса (если нужна локальная сборка)
docker compose build <service_name>
docker compose config  # Проверка синтаксиса
docker compose up -d # Запуск
docker compose ps      # Проверка статуса

# Проверка логов
docker compose logs -f <service_name>

```
4. **Закоммить и создай Pull Request**

5. **Merge в главную ветку после review**


##  Мониторинг и логирование

### Система мониторинга (Prometheus + Grafana + cAdvisor)

**Prometheus** собирает метрики:
- cAdvisor (метрики контейнеров): CPU, Memory, время отклика, uptime, код ответа, статус доступности приложения
- Blackbox Exporter (HTTP health checks)
- Docker stats

**Grafana** визуализирует метрики для:
- Использования ресурсов контейнеров
- Доступности сервисов (uptime)
- Кастомных метрик приложения


### Система логирования (Elasticsearch + Fluentd + Kibana)

**Fluentd** собирает логи из:
- stdout контейнера `diplom-app` (Docker logging driver)
- Форматирует логи с помощью парсера regexp

**Elasticsearch** индексирует логи с автоматическим парсингом полей

**Kibana** позволяет работать с логами в UI интерфейсе

##  Автор
ConDoRrus21
