FROM golang:1.25 AS builder

WORKDIR /app
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM alpine:3.22
WORKDIR /app
COPY --from=builder /app/app .

EXPOSE 8080
CMD ["./app"]
