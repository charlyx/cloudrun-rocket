ARG TARGET=x86_64-unknown-linux-musl


FROM rustlang/rust:nightly-slim as builder

RUN apt-get update && apt-get install -y musl-tools --no-install-recommends

WORKDIR /usr/src/app

ARG TARGET
RUN rustup target add $TARGET

COPY . .

RUN cargo build --release --target $TARGET


FROM scratch

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080
ENV ROCKET_PORT $PORT

WORKDIR /usr/bin

ARG TARGET
COPY --from=builder /usr/src/app/target/$TARGET/release/helloworld-rust .

CMD ["helloworld-rust"]
