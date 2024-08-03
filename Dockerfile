FROM golang:1.18 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o url_shortener

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/url_shortener .
EXPOSE 8080

CMD ["./url_shortener"]
