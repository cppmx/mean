FROM node:latest as build

WORKDIR /app

COPY . .

RUN npm install

RUN npm run build

FROM nginx:latest

COPY --from=build /app/mean.local.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/frontend/browser/* /usr/share/nginx/html/
COPY --from=build /app/src/assets /usr/share/nginx/html/assets

EXPOSE 80
