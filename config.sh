#!/bin/bash

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

apt_install vim
apt_install tmux
apt_install git
apt_install g++
apt_install gcc
apt_install zsh
apt_install curl
apt_install ripgrep
apt_install fzf
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
    chsh -s $(which zsh)
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    info "ZSH is already configures, skipping..."
fi

info "Installing Google Chrome"
if [ $(which google-chrome | grep -c "not found") -ge 1 ]; then
    info "Installing Chrome"
    wget -O "google-chrome.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    chmod u+x "google-chrome.deb"
    sudo dpkg -i "google-chrome.deb" 
else
    info "Google Chrome is already installed, skipping..."
fi

