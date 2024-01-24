# Используем образ с Java и Gradle
FROM gradle:latest AS builder

# Устанавливаем рабочую директорию
WORKDIR /app/eureka-server

# Копируем файлы с зависимостями и сборки
COPY build.gradle .
COPY settings.gradle .
COPY src src

# Собираем проект
RUN gradle build --no-daemon --exclude-task test

# Используем минимальный образ с JRE
FROM openjdk:17

# Устанавливаем рабочую директорию
WORKDIR /app/eureka-server

# Копируем JAR файл из предыдущего этапа сборки
COPY --from=builder /app/eureka-server/build/libs/eureka-server-0.0.1-SNAPSHOT.jar .

# Задаем команду для запуска приложения
CMD ["java", "-Dspring.profiles.active=prod", "-jar", "eureka-server-0.0.1-SNAPSHOT.jar"]