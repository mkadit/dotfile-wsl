#!/bin/bash

# Change to your preferred directory
cd /tmp
pwd

# Download the tar.gz
# curl -LO https://github.com/tstack/lnav/releases/download/v0.12.4/lnav-0.12.4.tar.gz
curl -LO https://github.com/tstack/lnav/releases/download/v0.13.0-beta4/lnav-0.13.0-beta4.tar.gz

# Extract it
# tar -xzf lnav-0.12.4.tar.gz
tar -xzf lnav-0.13.0-beta4.tar.gz

# Change into the extracted directory
# cd lnav-0.12.4
# cd lnav-0.12.4
cd lnav-0.13.0

# Build prerequisites (install if not already installed)
sudo apt update
sudo apt install -y \
  git g++ make autoconf automake libtool \
  libreadline-dev libncurses5-dev libcurl4-openssl-dev \
  libpcre2-dev libbz2-dev zlib1g-dev libsqlite3-dev \
  pkg-config libcurlpp-dev libfmt-dev libspdlog-dev \
  libzip-dev libyaml-cpp-dev libunistring-dev

./configure

# Compile
# make -j$(nproc)
make

sudo make install
