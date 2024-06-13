#!/bin/bash

# Configure zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -k chsh -s $(which zsh) ${USER}

# Install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Install zsh plugins
${HOME}/cargo/.bin/cargo install sheldon --locked
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

echo 'eval "$(sheldon init --shell zsh)"' >> ~/.zshrc
echo 'ZVM_VI_INSERT_ESCAPE_BINDKEY=jk' >> ~/.zshrc
