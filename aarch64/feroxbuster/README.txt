On aarch64, link the binaries accordingly
https://archlinux.org/packages/extra/x86_64/aarch64-linux-gnu-gcc/

sudo ln -s /usr/include /usr/aarch64-linux-gnu
sudo ln -s /usr/lib/gcc/aarch64-unknown-linux-gnu /usr/lib/gcc/aarch64-linux-gnu
sudo ln -s /usr/bin/c++ /usr/bin/aarch64-linux-gnu-c++
sudo ln -s /usr/bin/cpp /usr/bin/aarch64-linux-gnu-cpp
sudo ln -s /usr/bin/g++ /usr/bin/aarch64-linux-gnu-g++
sudo ln -s /usr/bin/gcc /usr/bin/aarch64-linux-gnu-gcc
