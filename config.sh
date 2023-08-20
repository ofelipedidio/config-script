#!/bin/bash

# Running this script multiple times is not supposed to reinstall anything the system

info() {
    echo -e "[\033[94mINFO\033[0m] \033[37m"$@"\033[0m" 1>&2
}

apt_install() {
    info "Installing" #@
    sudo apt install $@ -y
}

snap_install() {
    info "Installing $1"
    sudo snap install $@ 
}

dpkg_install() {
    info "Installing $1"
    if [ "$(which "$2" | wc -l)" -ne 1 ]; then
        wget -O package.deb "$3"
        sudo dpkg -i package.deb
        rm package.deb
    else
        info "$1 is already installed, skipping..."
    fi
}

info "Updating APT"
sudo apt update
info "Refreshing Snap"
sudo snap refresh

apt_install curl git g++ gcc xclip ripgrep fzf tmux zsh vim openssl  python3.11 python3-pip python3.11-venv npm inkscape fuse cmake
snap_install nvim --classic
snap_install discord
snap_install libreoffice

dpkg_install "Obsidian" "obsidian" "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.3.5/obsidian_1.3.5_amd64.deb"
dpkg_install "Google Chrome" "google-chrome" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

info "Configuring git"
git config --global user.email "felipe.sdidio@gmail.com"
git config --global user.name "Felipe Didio"
git config --global core.editor "nvim"

info "Configuring nvim"
if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim 
    git clone --depth 1 https://github.com/ofelipedidio/nvim-config ~/.config/nvim
else
    info "Nvim is already configured, skipping..."
fi

info "Configuring ZSH"
if [ ! $(echo "$SHELL" | grep -c zsh) -ge 1 ]; then
    info "Configuring ZSH - Installing oh-my-zsh"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    info "Configuring ZSH - Configuring theme"
    cp ./my_robbyrussell.zsh-theme ~/.oh-my-zsh/themes/
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="my_robbyrussell"/gi' ~/.zshrc
    info "Configuring ZSH - Additional configurations"
    cp ./.zshconfig ~
    echo "source ~/.zshconfig" >> ~/.zshrc
else
    info "ZSH is already configured, skipping..."
fi

info "Installing Rust"
if [ "$(which rustup | wc -l)" -ne 1 ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
    chmod +x rustup.sh
    ./rustup.sh -y -c rustc -c cargo -c rustfmt -c rust-std -c rust-docs -c rust-analyzer -c clippy -c rust-src
    rm rustup.sh
    source "$HOME/.cargo/env"
else
    info "Rust is already installed, skipping..."
fi

