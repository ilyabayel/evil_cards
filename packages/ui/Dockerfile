FROM node:16-alpine as builder

COPY ./ ./

RUN apk update && apk add python3 g++ make ocaml
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip
RUN cd ./ && yarn && yarn build

FROM nginx:1.23.1-alpine as deploy

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder ./dist /usr/share/nginx/