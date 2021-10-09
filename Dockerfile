FROM k8s.gcr.io/leader-elector:0.5 as source

FROM alpine:3.14 as temp

COPY /rootfs /
COPY --from=source /server /app/
RUN chmod +x /app/*.sh

FROM alpine:3.14

ENV QUIET=true

COPY --from=temp --chown=1000:1000 /app /

RUN addgroup -g 1000 leader && adduser -u 1000 -S -D -G leader leader && \
    apk add --no-cache curl

USER leader

ENTRYPOINT ["/run.sh"]
CMD []