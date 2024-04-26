FROM golang:alpine AS wigomaster
WORKDIR /go/src/github.com/nikitamirzani323/goapibackend
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app .


# Moving the binary to the 'final Image' to make it smaller
FROM alpine:latest as wigomasterrelease
WORKDIR /app
RUN apk add tzdata
RUN mkdir -p ./frontend/public
COPY --from=wigomaster /go/src/github.com/nikitamirzani323/goapibackend/app .
COPY --from=wigomaster /go/src/github.com/nikitamirzani323/goapibackend/env-sample /app/.env

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 1111
CMD ["./app"]