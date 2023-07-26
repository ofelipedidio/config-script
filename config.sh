#!/bin/bash

# Running this script multiple times is not supposed to break the system

info() {
    echo -e "[\033[94mINFO\033[0m] \033[37m"$@"\033[0m" 1>&2
}

apt_install() {
    info "Installing $1"
    sudo apt install "$1" -y
}

snap_install() {
    info "Installing $1"
    sudo snap install "$1"
}

info "Updating APT"
sudo apt update
info "Refreshing Snap"
sudo snap refresh

apt_install curl
apt_install git
apt_install g++
apt_install gcc
apt_install xclip
apt_install ripgrep
apt_install fzf
apt_install tmux
apt_install zsh
apt_install vim
snap_install nvim
snap_install discord

info "Configuring git"
git config --global user.email "felipe.sdidio@gmail.com"
git config --global user.name "Felipe Didio"
git config --global core.editor "nvim"

info "Configuring nvim"
if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim 
    git clone --depth 1 git@github.com:ofelipedidio/nvim-config.git ~/.config/nvim
else
    info "Nvim is already configured, skipping..."
fi

info "Configuring ZSH"
if [ ! $(echo "$SHELL" | grep -c zsh) -ge 1 ]; then
    info "Configuring ZSH - Installing oh-my-zsh"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    info "Configuring ZSH - Configuring theme"
    mv ./my_robbyrussell.zsh-theme ~/.oh-my-zsh/themes/
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="my_robbyrussell"/gi' ~/.zshrc

    info "Configuring ZSH - Additional configurations"
    mv ./.zshconfig ~
    echo "source ~/.zshconfig" >> ~/.zshrc
else
    info "ZSH is already configured, skipping..."
fi

info "Installing Google Chrome"
if [ "$(which google-chrome | wc -l)" -ne 1 ]; then
    info "Installing Chrome"
    wget -O google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    chmod u+x google-chrome.deb
    sudo dpkg -i google-chrome.deb
    rm google-chrome.deb
else
    info "Google Chrome is already installed, skipping..."
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
