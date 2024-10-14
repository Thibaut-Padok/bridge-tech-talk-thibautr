FROM node:16-alpine3.17

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install & npm i body-parser

# To be able to do some test from the container
RUN apk update && apk add net-tools && apk add curl

COPY index.js .
EXPOSE 3000

CMD ["node", "--inspect-port=0.0.0.0:9229", "index.js"]
