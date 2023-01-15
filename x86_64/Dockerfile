FROM rust:latest

RUN apt-get update  && apt-get install -y \ 
    bc libncurses-dev gawk flex bison openssl \
    libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev \
    autoconf build-essential kmod cpio\
    clang llvm \
    qemu-system-x86

RUN set -eux; \
    cd /root; \
    URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.4.tar.xz"; \
    wget $URL \
    && tar Jxf linux-6.1.4.tar.xz \
    && cd linux-6.1.4 \
    && rustup override set $(scripts/min-tool-version.sh rustc) \
    && rustup component add rust-src \
    && cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen \
    && rustup component add rustfmt \
    && rustup component add clippy;

COPY x86_64_rust_defconfig /root/linux-6.1.4/arch/x86/configs/x86_64_rust_defconfig

RUN cd /root/linux-6.1.4 \
    && make CC=clang x86_64_rust_defconfig \
    && make CC=clang CLIPPY=1 -j$(nproc)

ENTRYPOINT [ "/usr/bin/tail", "-f", "/dev/null" ]
