FROM rust:bookworm

# ARG MIRAI_VERSION=v1.1.8
ARG MIRAI_VERSION=main
ARG MIRAI_REPO=https://github.com/facebookexperimental/MIRAI.git

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
  && apt-get install --no-install-recommends -q -y \
    build-essential cmake libclang-15-dev \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

RUN cd /opt/ \
  && git clone --depth=1 -b "$MIRAI_VERSION" "$MIRAI_REPO" mirai-src \
  && cd mirai-src \
  && cargo install --locked --path checker \
  && rustup default $(cat rust-toolchain.toml | grep channel | cut -d '=' -f 2 | sed 's/ *"//g')

COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
