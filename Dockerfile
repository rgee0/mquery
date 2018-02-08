FROM golang:1.8.5 as builder
MAINTAINER docker@technologee.co.uk

WORKDIR /go/src/github.com/rgee0/mquery
COPY . /go/src/github.com/rgee0/mquery

RUN go-wrapper download

RUN CGO_ENABLED=0 go build -a -ldflags "-s -w" .

FROM alpine:latest
MAINTAINER docker@technologee.co.uk

WORKDIR /root/
RUN apk --no-cache add ca-certificates
ENTRYPOINT []

COPY --from=builder /go/src/github.com/rgee0/mquery/mquery    .
ADD https://github.com/openfaas/faas/releases/download/0.7.0/fwatchdog /usr/bin
RUN chmod +x /usr/bin/fwatchdog

ENV fprocess ["./mquery"]

CMD [ "/usr/bin/fwatchdog"]