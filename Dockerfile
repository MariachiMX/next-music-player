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

EXPOSE 3000

CMD ["pnpm dev"]