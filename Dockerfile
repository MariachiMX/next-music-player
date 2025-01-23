# Usa una imagen base con Node.js 23 y pnpm ya instalados
FROM node:23-alpine3.18

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración de pnpm para aprovechar el caché de capas
#COPY pnpm-lock.yaml pnpm-workspace.yaml ./

# Instala las dependencias con pnpm
RUN npm install -g pnpm@10
RUN pnpm install

# Copia el resto del código fuente
COPY . .

# Expone el puerto que utiliza la aplicación (ajústalo según tu aplicación)
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["pnpm", "start"]