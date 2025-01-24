FROM node:alpine

WORKDIR /app

# Copia los archivos necesarios
COPY package*.json pnpm-lock.yaml ./
COPY . .

# Instala pnpm
RUN npm install -g pnpm

# Instala las dependencias (incluyendo las de desarrollo)
RUN pnpm install

EXPOSE 3000

CMD ["pnpm", "run", "dev"]