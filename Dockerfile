FROM node:14.2.0-alpine3.11 as build
WORKDIR /app
#RUN npm install -g @angular/cli
RUN npm install -g @angular/cli -g

COPY ./package.json .
RUN npm install
COPY . .
RUN ng build --prod

FROM nginx:1.17.1-alpine
#FROM nginx as runtime
COPY --from=build /app/dist/MyAngularApp /usr/share/nginx/html
