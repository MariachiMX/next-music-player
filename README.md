# Ejecutar proyecto localmente con Docker Compose (basado en pipeline de Jenkins)

Estas instrucciones te guiarán para ejecutar tu proyecto localmente usando Docker Compose, replicando la configuración que tienes en tu pipeline de Jenkins.

## Prerrequisitos

*   **Docker y Docker Compose:** Asegúrate de tener Docker Desktop (para Windows y macOS) o Docker Engine y Docker Compose (para Linux) instalados. Puedes encontrar las instrucciones de instalación en el sitio web oficial de Docker: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
*   **Código fuente:** Debes tener el código fuente de tu proyecto en tu máquina local. Clona el repositorio de GitHub:

    ```bash
    git clone <URL_del_repositorio>
    cd <nombre_del_repositorio>
    ```

## Archivos necesarios

Debes tener los archivos `Dockerfile` (o `Dockerfile.dev` para desarrollo) y `docker-compose.yml` en la raíz de tu proyecto local. Estos archivos deberían estar en tu repositorio de código fuente.

## Ejecutar la aplicación

1.  **Abre una terminal** en el directorio raíz de tu proyecto (donde están `Dockerfile` y `docker-compose.yml`).

2.  **Ejecuta el siguiente comando:**

    ```bash
    docker-compose up -d --build
    ```

    *   `docker-compose up`: Inicia los contenedores definidos en `docker-compose.yml`.
    *   `-d`: Ejecuta los contenedores en modo "detached" (en segundo plano).
    *   `--build`: Reconstruye las imágenes si han cambiado los Dockerfiles o si las imágenes no existen.

3.  **Accede a la aplicación:**

    Una vez que los contenedores se estén ejecutando, podrás acceder a tu aplicación en `http://localhost:<puerto>`. Reemplaza `<puerto>` con el puerto que hayas mapeado en tu archivo `docker-compose.yml` (generalmente el puerto 3000).

## Ejemplo de docker-compose.yml (con base de datos PostgreSQL)

```yaml
version: "3.9"
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev # O Dockerfile para producción
    ports:
      - "3000:3000"
    depends_on:
      - postgres
    environment:
      - POSTGRES_URL=postgres://postgres:postgres@postgres:5432/postgres # Reemplaza con tus credenciales reales
      - CHOKIDAR_USEPOLLING=true #Soluciona problemas de hot reloading con volumenes
      - WATCHPACK_POLLING=true #Soluciona problemas de hot reloading con volumenes
    volumes:
      - .:/app # Monta el directorio local para desarrollo
    stdin_open: true
    tty: true
  postgres:
    image: postgres:16.4-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres # ¡CAMBIA ESTA CONTRASEÑA EN PRODUCCIÓN!
      POSTGRES_DB: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      volumes:
      postgres_data:


