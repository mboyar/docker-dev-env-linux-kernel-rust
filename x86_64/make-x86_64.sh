#!/bin/bash

LINUX_PATH="/root/linux"
BUILDROOT_PATH="/root/buildroot"
ARG1=$1

if [[ -d $LINUX_PATH && -d $BUILDROOT_PATH ]]; then
    
    case "$ARG1" in
        linux_defconfig)
            cd $LINUX_PATH && make CC=clang x86_64_rust_defconfig
            ;;
        linux_build)
            cd $LINUX_PATH && make CC=clang CLIPPY=1 -j$(nproc) \
            && make INSTALL_MOD_PATH=../modinstall modules_install
            ;;
        buildroot_defconfig)
            cd $BUILDROOT_PATH && make qemu_x86_64_nolinux_defconfig
            ;;
        buildroot_build)
            cd $BUILDROOT_PATH && make -j$(nproc)
            ;;
        qemu-run)
            cd $KERNEL_PATH && qemu-system-x86_64 -kernel linux/arch/x86/boot/bzImage -boot c -m 2049M -hda buildroot/output/images/rootfs.ext2 \
            -append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" -serial stdio -display none
            ;;
        *)
            echo "Usage: ${0##*/} <linux_defconfig|linux_build|buildroot_defconfig|buildroot_build|qemu-run>"; exit 253
            ;;
    esac
else
    echo "$LINUX_PATH or $BUILDROOT_PATH could not be found!"; exit 254
fi
