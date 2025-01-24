# Stage 1: Build stage
FROM node:alpine AS builder

WORKDIR /app

# Copia solo los archivos necesarios para las dependencias
COPY package*.json ./
RUN npm install --omit=dev # Instala solo dependencias de producción

# Instala pnpm globalmente en la etapa de builder
RUN npm install -g pnpm

# Copia el resto del código fuente
COPY . .

# Compila el código TypeScript si es necesario
RUN npm run build # Asegúrate de tener este script en package.json

ARG SETUP_CONFIG=L
ENV SETUP_CONFIG=${SETUP_CONFIG}
RUN npm run db:setup

COPY tracks /app/tracks

RUN npm run db:migrate
RUN npm run db:seed

# Stage 2: Production stage
FROM node:alpine

WORKDIR /app

# Copia pnpm desde la etapa de builder
COPY --from=builder /usr/local/bin/pnpm /usr/local/bin/pnpm #Copia pnpm
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public # Si tienes archivos estáticos
COPY --from=builder /app/.next ./.next # Si usas Next.js
COPY --from=builder /app/build ./build # Si usas otro builder
COPY --from=builder /app/tracks ./tracks
COPY --from=builder /app/.env ./.env #Si usas variables de entorno

EXPOSE 3000

CMD ["pnpm", "run", "start"]