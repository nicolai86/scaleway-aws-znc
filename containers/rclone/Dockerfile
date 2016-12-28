FROM alpine:3.4

ENV GOPATH /go

RUN apk add --update go git ca-certificates \
  && go get github.com/ncw/rclone \
  && cp /go/bin/rclone /usr/bin \
  && rm -rf /go \
  && apk del go git \
  && rm -rf /tmp/* /var/cache/apk/*

ADD ./.rclone.conf /root/
ADD ./entrypoint.sh /
ADD ./s3-sync.sh /etc/periodic/15min/s3-sync

RUN chmod +x /entrypoint.sh && \
  chmod +x /etc/periodic/15min/s3-sync

CMD /entrypoint.sh
