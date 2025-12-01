# ============================
#        BUILD STAGE
# ============================
FROM golang:1.25 AS builder

# Рабочая директория
WORKDIR /app

# Копируем модули
COPY go.mod go.sum ./
RUN go mod download

# Копируем код
COPY . .

# Сборка бинарника (статическая, быстрая)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app .


# ============================
#       RUNTIME STAGE
# ============================
FROM alpine:3.19

# Устанавливаем сертификаты (без этого HTTPS не работает)
RUN apk add --no-cache ca-certificates

# Рабочая директория
WORKDIR /app

# Копируем бинарник
COPY --from=builder /app/app .

# Открываем порт Gin
EXPOSE 8080

# Запуск приложения
CMD ["./app"]
