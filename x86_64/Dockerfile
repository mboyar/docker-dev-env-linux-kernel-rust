FROM rust:latest

ENV KERNEL_VERSION="6.1.4"
ENV BUILDROOT_VERSION="2023.02"

RUN apt-get update  && apt-get install -y \ 
    bc libncurses-dev gawk flex bison openssl \
    libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev \
    autoconf build-essential kmod cpio\
    clang llvm rsync\
    qemu-system-x86 

RUN set -eux; \
    cd /root; \
    wget "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz" \    
    && tar Jxf linux-${KERNEL_VERSION}.tar.xz \
    && ln -s linux-${KERNEL_VERSION} linux; cd linux \
    && rustup override set $(scripts/min-tool-version.sh rustc) \
    && rustup component add rust-src \
    && cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen \
    && rustup component add rustfmt \
    && rustup component add clippy;

RUN set -eux; \
    cd /root; \
    wget https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz \
    && tar zxf buildroot-${BUILDROOT_VERSION}.tar.gz \
    && ln -s buildroot-${BUILDROOT_VERSION} buildroot

COPY linux_x86_64_rust_defconfig /root/linux/arch/x86/configs/x86_64_rust_defconfig
COPY buildroot_qemu_x86_64_nolinux_defconfig /root/buildroot/configs/qemu_x86_64_nolinux_defconfig
COPY make-x86_64.sh /root/

ENTRYPOINT [ "/usr/bin/tail", "-f", "/dev/null" ]
