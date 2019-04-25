FROM rustlang/rust:nightly-slim as builder

WORKDIR /usr/src/app

COPY . .

RUN cargo build --release

FROM debian:stretch-slim

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080
ENV ROCKET_PORT $PORT

WORKDIR /usr/bin

COPY --from=builder /usr/src/app/target/release/helloworld-rust .

CMD ["helloworld-rust"]
