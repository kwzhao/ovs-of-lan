#!/bin/bash

# Configure zsh
chsh -s $(which zsh) $(whoami)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
. "$HOME/.cargo/env"

# Install zsh plugins
cargo install sheldon --locked
mkdir -p ~/.sheldon

# Create and configure plugins.toml
cat << EOF > ~/.sheldon/plugins.toml
[[plugins]]
name = "zsh-autosuggestions"
github = "zsh-users/zsh-autosuggestions"

[[plugins]]
name = "zsh-syntax-highlighting"
github = "zsh-users/zsh-syntax-highlighting"

[[plugins]]
name = "zsh-vi-mode"
github = "jeffreytse/zsh-vi-mode"
EOF
