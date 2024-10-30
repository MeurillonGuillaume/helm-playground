FROM docker.be-mobile.biz:5000/golang:1.22.5-alpine3.20 AS go-build
WORKDIR /build
COPY . .
RUN make test
RUN make build

FROM nginx:alpine AS runtime
WORKDIR /usr/share/nginx/html
COPY --from=go-build /build/dist dist/
COPY *.html .
COPY style.css .
COPY *.js .
COPY favicon.png .
COPY codemirror/ codemirror/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]