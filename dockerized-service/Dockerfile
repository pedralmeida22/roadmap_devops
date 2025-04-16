FROM node:23-slim

WORKDIR /usr/app

COPY app/ /usr/app
COPY .env /usr

RUN npm install

CMD [ "node", "index.js" ]
