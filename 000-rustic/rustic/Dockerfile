FROM ghcr.io/rustic-rs/rustic:latest as upstream

FROM alpine:3.21
RUN apk add --no-cache tzdata rclone
COPY --from=upstream /rustic /usr/local/bin/rustic
ENV TZ=Asia/Taipei
CMD ["/bin/sleep", "infinity"]
