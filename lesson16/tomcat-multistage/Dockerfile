# Stage 1: сборка
FROM eclipse-temurin:17-jdk AS build

# Установка Apache Ant для сборки:
RUN apt-get update && \
    apt-get install -y ant git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# выбор рабочей директории:
WORKDIR /tomcat-build

# Клонирование исходного кода Apache Tomcat из GitHub:
RUN git clone --depth 1 --branch 10.1.x https://github.com/apache/tomcat.git .

# Создание файла конфигурации для сборки:
RUN echo "base.path=/tomcat-build-libs" > build.properties

# Выполнение сборки Apache Tomcat с помощью Ant:
RUN ant

# Stage 2: запуск
FROM eclipse-temurin:17-jre-jammy

# Создание пользователя для запуска Tomcat:
RUN groupadd -r tomcat && \
    useradd -r -g tomcat -d /opt/tomcat -s /bin/bash tomcat

# Установка переменных окружения для Tomcat:
ENV CATALINA_HOME=/opt/tomcat
ENV CATALINA_BASE=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# Создание директории для Tomcat:
RUN mkdir -p $CATALINA_HOME

# Копирование собранного Tomcat из build stage:
COPY --from=build /tomcat-build/output/build/ $CATALINA_HOME/

# Настройка прав доступа:
RUN chown -R tomcat:tomcat $CATALINA_HOME && \
    chmod +x $CATALINA_HOME/bin/*.sh

# Переключение на пользователя tomcat:
USER tomcat

# Открытие HTTP порта:
EXPOSE 8080

# Рабочая директория:
WORKDIR $CATALINA_HOME

# Запуск Tomcat через catalina.sh:
ENTRYPOINT ["catalina.sh", "run"]
