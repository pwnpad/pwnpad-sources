#!/bin/sh

VERSION="4.34c"

# Ubuntu build script
# docker run --rm -it ubuntu:25.04
apt-get update
apt-get install -y build-essential python3-dev automake cmake git flex bison libglib2.0-dev libpixman-1-dev python3-setuptools cargo libgtk-3-dev
apt-get install -y lld-14 llvm-14 llvm-14-dev clang-14 || apt-get install -y lld llvm llvm-dev clang
apt-get install -y gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev
apt-get install -y python3-pip
apt-get install -y ninja-build
apt-get install -y gcc-aarch64-linux-gnu
apt-get install -y gcc-i686-linux-gnu
apt-get install -y gcc-x86-64-linux-gnu

cd $HOME

git clone --branch=v${VERSION} https://github.com/AFLplusplus/AFLplusplus
cd AFLplusplus

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

tar czvf aflplusplus-${VERSION}.tgz usr/
