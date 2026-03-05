FROM ghcr.io/rustic-rs/rustic:latest as upstream
FROM alpine:3.21
COPY --from=upstream /rustic /usr/local/bin/rustic
CMD ["/bin/sleep", "infinity"]
