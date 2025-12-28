#!/bin/sh

VERSION="4.35c"

# Ubuntu build script
# docker run --rm -it ubuntu:26.04
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo libgtk-3-dev
# try to install llvm-18 and install the distro default if that fails
apt-get install -y lld-18 llvm-18 llvm-18-dev clang-18 || apt-get install -y lld llvm llvm-dev clang
apt-get install -y gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev
apt-get install -y meson ninja-build # for QEMU mode
apt-get install -y cpio libcapstone-dev # for Nyx mode
apt-get install -y wget curl # for Frida mode
apt-get install -y python3-pip python3-venv # for Unicorn mode
# for qemu mode
apt-get install -y gcc-aarch64-linux-gnu
apt-get install -y gcc-i686-linux-gnu
apt-get install -y gcc-x86-64-linux-gnu

cd $HOME

git clone --branch=v${VERSION} --depth=1 https://github.com/AFLplusplus/AFLplusplus
cd AFLplusplus
git submodule update --init

MAKEFLAGS="-j$(nproc)" make distrib

cd qemu_mode/

MAKEFLAGS="-j$(nproc)" CPU_TARGET=aarch64 CROSS=/usr/bin/aarch64-linux-gnu-gcc ./build_qemu_support.sh
mv ../afl-qemu-trace ../afl-qemu-trace-aarch64

MAKEFLAGS="-j$(nproc)" CPU_TARGET=x86_64 CROSS=/usr/bin/x86_64-linux-gnu-gcc ./build_qemu_support.sh
mv ../afl-qemu-trace ../afl-qemu-trace-x86_64

MAKEFLAGS="-j$(nproc)" CPU_TARGET=i386 CROSS=/usr/bin/i686-linux-gnu-gcc ./build_qemu_support.sh
mv ../afl-qemu-trace ../afl-qemu-trace-i386

cd ..

make DESTDIR="$HOME" PREFIX=/usr install

cp afl-qemu-trace-aarch64 $HOME/usr/bin
cp afl-qemu-trace-i386 $HOME/usr/bin
cp afl-qemu-trace-x86_64 $HOME/usr/bin

ln -s afl-qemu-trace-$(uname -m) $HOME/usr/bin/afl-qemu-trace

cd $HOME

tar czvf aflplusplus-${VERSION}-$(uname -m).tgz usr/
