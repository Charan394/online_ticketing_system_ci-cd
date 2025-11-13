FROM node:18-alpine AS base

WORKDIR  /app

COPY package-lock.json package.json ./

RUN npm install 

COPY . .

ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build

FROM nginx:1.29.3-alpine

COPY --from=base /app/build/  /usr/share/nginx/html

EXPOSE 80

