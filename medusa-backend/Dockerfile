FROM node:20-alpine

WORKDIR /server

RUN npm install -g pnpm@10

COPY package.json ./
COPY .npmrc ./
RUN pnpm install

COPY . .

EXPOSE 9000 7001

ENTRYPOINT ["./start.sh"]