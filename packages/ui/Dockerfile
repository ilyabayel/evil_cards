FROM node:16 as builder

COPY ./ ./

RUN cd ./ && yarn && yarn build

FROM nginx:1.23.1-alpine as deploy

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder ./dist /usr/share/nginx/