# Imagen base
FROM node:18-alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar dependencias necesarias para paquetes nativos
RUN apk add --no-cache \
    bash \
    git \
    curl \
    ffmpeg \
    python3 \
    py3-pip \
    build-base

# Clonar el repositorio
RUN git clone https://github.com/leerob/next-music-player /app

# Establecer el directorio de trabajo dentro del proyecto clonado
WORKDIR /app

# Instalar pnpm
RUN npm install -g pnpm

# Instalar las dependencias del proyecto
RUN pnpm install

# Copiar archivos de audio locales (paso opcional para builds locales)
# COPY tracks /app/tracks

# Exponer el puerto que utiliza la aplicación
EXPOSE 3000

# Configurar la base de datos y llenarla con datos iniciales
RUN pnpm db:setup && pnpm db:migrate && pnpm db:seed

# Iniciar el servidor de desarrollo
CMD ["pnpm", "dev"]
