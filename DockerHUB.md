# Registrar imágenes Docker en Docker Hub usando Docker Compose

Este documento detalla el proceso para subir imágenes Docker a Docker Hub utilizando Docker Compose, cubriendo desde la preparación hasta la automatización en CI/CD.

## 1. Preparación: Archivos `docker-compose.yml` y Dockerfile

Antes de comenzar, asegúrate de tener los siguientes archivos configurados:

*   **`docker-compose.yml`:** Define los servicios de tu aplicación multi-contenedor. Esencial para construir la imagen.

    ```yaml
    version: "3.9" # O la versión que utilices
    services:
      web: # Nombre del servicio (usado en `docker-compose build`)
        build:
          context: .       # Directorio del Dockerfile (generalmente el actual)
          dockerfile: Dockerfile # Nombre del Dockerfile
        ports:
          - "3000:3000" # Mapeo de puertos (opcional, para desarrollo local)
        # ... otras configuraciones (volúmenes, dependencias, etc.)
    ```

*   **Dockerfile:** Contiene las instrucciones para construir la imagen. Debe estar en el directorio `context` de `docker-compose.yml`.

## 2. Construir la imagen

*   **Con Docker Compose:**

    ```bash
    docker-compose build <nombre_del_servicio>
    ```

    Ejemplo:

    ```bash
    docker-compose build web
    ```

*   **Sin Docker Compose (solo Dockerfile):**

    ```bash
    docker build -t <nombre_imagen>:<tag> . # El punto indica el contexto (directorio actual)
    ```

    Ejemplo:

    ```bash
    docker build -t mi-app:local .
    ```

## 3. Etiquetar la imagen para Docker Hub

Para que Docker Hub reconozca tu imagen, debe tener el formato correcto:

```bash
docker tag <id_o_nombre_imagen_local> <nombre_de_usuario_dockerhub>/<nombre_del_repositorio>:<tag>