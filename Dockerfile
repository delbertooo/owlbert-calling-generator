FROM node:14.15.0 as build-stage
WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY ./ .
RUN yarn build

FROM nginx:1-alpine as production-stage
RUN mkdir /app
COPY --from=build-stage /app/dist /app
COPY docker/nginx.conf /etc/nginx/nginx.conf
