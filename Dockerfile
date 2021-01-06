FROM golang:alpine AS builder

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go
ENV SOURCEPATH ${GOPATH}/src/github.com/juruen/rmapi

RUN apk add --no-cache \
    bash

COPY . ${SOURCEPATH}

RUN set -x \
    && cd ${SOURCEPATH} \
    && go build . \
    && mv rmapi /usr/bin/rmapi


FROM alpine:latest

COPY --from=builder /usr/bin/rmapi /usr/local/bin/rmapi

RUN adduser -D -u 1000 user \
    && chown -R user /home/user

RUN apk add --no-cache python3 py3-pip \
    && pip3 install pyzotero pydash python-dotenv

USER user

ENV USER user

WORKDIR /home/user

COPY zotrm.py /home/user/

# ENTRYPOINT [ "rmapi" ]
ENTRYPOINT [ "sh" ]

# /usr/bin/python3 /home/user/zotrm.py -v
