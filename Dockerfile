# Usa una imagen base con Node.js 23 y pnpm ya instalados
FROM node:18-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración de pnpm para aprovechar el caché de capas
COPY package.json ./
COPY pnpm-lock.yaml ./

# Instala las dependencias con pnpm
RUN npm install -g pnpm@10
RUN pnpm install
# Copia el resto del código fuente
COPY . .

# Expone el puerto que utiliza la aplicación (ajústalo según tu aplicación)
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["pnpm", "dev"]