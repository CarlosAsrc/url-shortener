FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/main.go

FROM scratch
COPY --from=builder /app/main /app/main
COPY config/ /app/config/
COPY --from=builderStep /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
EXPOSE 8080
ENTRYPOINT ["/app/main"]
