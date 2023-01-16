#!/bin/bash

KERNEL_PATH="/root/linux-6.1.4"
ARG1=$1

if [[ -d $KERNEL_PATH ]]; then
    
    cd $KERNEL_PATH

    case "$ARG1" in
        config)
            make CC=clang x86_64_rust_defconfig
            ;;
        build)
            make CC=clang CLIPPY=1 -j$(nproc)
            ;;
        run)
            qemu-system-x86_64 -kernel arch/x86/boot/bzImage -hda /dev/zero \
            -append "root=/dev/zero console=ttyS0" -serial stdio -display none
            ;;
        *)
            echo "Usage: ${0##*/} <config|build|run>"; exit 253
            ;;
    esac
else
    echo "$KERNEL_PATH could not be found!"; exit 254
fi
