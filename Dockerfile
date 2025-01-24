FROM node:alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .

WORKDIR /app

ARG SETUP_CONFIG=L
ENV SETUP_CONFIG=${SETUP_CONFIG}
RUN npm run db:setup

COPY tracks /app/tracks

RUN npm run db:migrate
RUN npm run db:seed

FROM node:alpine

WORKDIR /app
COPY . .
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