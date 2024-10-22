FROM rust:1.80 AS builder

RUN mkdir /build
WORKDIR /build
COPY ./ .

RUN cargo build --release --features azure

FROM alpine

RUN apk add -U ca-certificates

WORKDIR /build

COPY --from=builder /build/target/release/kafka-delta-ingest ./
ENTRYPOINT ["/build/kafka-delta-ingest"]
