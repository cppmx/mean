FROM node:slim

ENV NODE_ENV development

WORKDIR /app

COPY . .

RUN npm install

USER 1001

CMD [ "node", "server.js" ]

EXPOSE 3000