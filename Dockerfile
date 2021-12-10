FROM golang:1.15 as builder

ENV GO111MODULE=on
ENV GOPROXY=goproxy.cn,direct

WORKDIR $GOPATH/src/node-exporter-demo

COPY go.mod go.mod
COPY go.sum go.sum
RUN for iter in {1..10}; do \
    go mod download && \
    exit_code=0 && break || exit_code=$? && echo "apk error: retry $iter in 10s" && sleep 10; done; \
    (exit $exit_code)

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -p 3 -installsuffix cgo -o $GOPATH/src/node-exporter-demo/bin/node-exporter-demo .
RUN chmod +x $GOPATH/src/node-exporter-demo/bin/node-exporter-demo

FROM alpine:3.13
COPY --from=builder /go/src/node-exporter-demo/bin/node-exporter-demo /node-exporter-demo/node-exporter-demo
WORKDIR /node-exporter-demo
EXPOSE 8080
CMD ["/node-exporter-demo/node-exporter-demo"]