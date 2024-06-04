FROM mirror.gcr.io/golang:1.21 AS builder
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download 
COPY *.go ./ 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./parcel 

FROM mirror.gcr.io/alpine
WORKDIR /app
COPY tracker.db /app/
COPY --from=builder /build/parcel /app/parcel
CMD ["/app/parcel"]
