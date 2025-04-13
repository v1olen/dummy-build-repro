FROM rust:1.85 AS builder
RUN cargo install cargo-binstall
RUN cargo binstall dioxus-cli --version 0.6.3 --force -y

COPY . /opt
WORKDIR /opt

RUN dx bundle --platform web

ENV PORT=8080
EXPOSE 8080

WORKDIR /opt/target/dx/dummy-build-repro/release/web
CMD ["/opt/target/dx/dummy-build-repro/release/web/server"]


