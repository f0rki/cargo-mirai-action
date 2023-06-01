FROM rust:latest

# ARG MIRAI_VERSION=v1.1.8
ARG MIRAI_VERSION=main
ARG MIRAI_REPO=https://github.com/facebookexperimental/MIRAI.git

RUN cd /opt/ \
  && git clone --depth=1 -b "$MIRAI_VERSION" "$MIRAI_REPO" mirai-src \
  && cd mirai-src \
  && cargo install --locked --path checker \
  && rustup default $(cat rust-toolchain.toml | grep channel | cut -d '=' -f 2 | sed 's/ *"//g')


ENTRYPOINT [ "cargo", "mirai" ]
