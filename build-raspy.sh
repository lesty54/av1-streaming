#!/bin/bash -e

USER=lucas
PI_IP=172.20.10.3
TARGET=aarch64-unknown-linux-gnu

sudo apt update
sudo apt install -y libclang-dev libv4l-dev

# Check if cargo is installed
if ! command -v cargo &> /dev/null
then
    echo "Cargo is not installed, proceeding to install it..."
    # Install rustup, Rust's version and toolchain manager
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    # Add cargo to path
    source $HOME/.cargo/env
    echo "Cargo has been installed!"
else
    echo "Cargo is already installed!"
fi

# build binary
cargo build --release --target $TARGET

# upload binary
ssh-copy-id $USER@$PI_IP
scp -r ./target/$TARGET/release/video-streaming $USER@$PI_IP:/tmp/
 