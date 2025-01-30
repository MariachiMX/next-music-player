FROM node:alpine

WORKDIR /app

# Copia los archivos necesarios
COPY package*.json pnpm-lock.yaml ./
COPY . .

#Instala bash
RUN apk add --no-cache bash

# Instala pnpm
RUN npm install -g pnpm

# Instala las dependencias (incluyendo las de desarrollo)
RUN pnpm install

ARG SETUP_CONFIG=R
ARG POSTGRES_URL=postgresql://postgres:postgres@postgres:5432/postgres
ARG BLOB_READ_WRITE_TOKEN=ONdl3XwotThgJCKCo97pTpD1
ENV SETUP_CONFIG=${SETUP_CONFIG}
ENV POSTGRES_URL=${POSTGRES_URL}
ENV BLOB_READ_WRITE_TOKEN=${BLOB_READ_WRITE_TOKEN}
RUN pnpm db:setup

EXPOSE 3000

CMD ["pnpm", "run", "dev"]