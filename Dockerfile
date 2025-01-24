FROM node:alpine

WORKDIR /app

# Copia los archivos necesarios
COPY package*.json pnpm-lock.yaml ./
COPY . .

# Instala pnpm
RUN npm install -g pnpm

# Instala las dependencias (incluyendo las de desarrollo)
RUN pnpm install

ARG SETUP_CONFIG=L 
ENV SETUP_CONFIG=${SETUP_CONFIG} 
RUN echo "L" | pnpm db:setup
RUN pnpm db:migrate
RUN pnpm db:seed

EXPOSE 3000

CMD ["pnpm", "run", "dev"]