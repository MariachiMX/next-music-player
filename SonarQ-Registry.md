# Configurar SonarQube en Docker y registrar imágenes en Docker Hub con Docker Compose

Este documento explica cómo configurar SonarQube usando Docker y cómo registrar tus imágenes Docker en Docker Hub, utilizando Docker Compose para la orquestación.

## Configurar SonarQube en Docker

Existen dos maneras principales de ejecutar SonarQube en Docker:

### 1. Usando la imagen oficial de SonarQube (Recomendado)

Esta es la forma más sencilla y recomendada. Utiliza la imagen oficial disponible en Docker Hub.

*   **Archivo `docker-compose.yml`:**

```yaml
version: "3.9"
services:
  sonarqube:
    image: sonarqube:lts-community # Usa la versión LTS (Long Term Support) para estabilidad
    ports:
      - "9000:9000" # Puerto para la interfaz web de SonarQube (acceso desde localhost:9000)
      - "9092:9092" # Puerto para el escáner de SonarQube
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://postgres:5432/sonarqube # Conexión a la base de datos
      - SONAR_JDBC_USERNAME=sonarqube
      - SONAR_JDBC_PASSWORD=sonarqube
    depends_on:
      - postgres # Dependencia de PostgreSQL
    volumes:
      - sonarqube_data:/opt/sonarqube/data # Persistencia de datos de SonarQube
      - sonarqube_extensions:/opt/sonarqube/extensions # Persistencia de extensiones
      - sonarqube_logs:/opt/sonarqube/logs # Persistencia de logs
  postgres:
    image: postgres:15 # Imagen de PostgreSQL
    environment:
      - POSTGRES_USER=sonarqube
      - POSTGRES_PASSWORD=sonarqube
      - POSTGRES_DB=sonarqube
    volumes:
      - postgres_data:/var/lib/postgresql/data # Persistencia de datos de PostgreSQL
volumes:
  sonarqube_data:
  sonarqube_extensions: