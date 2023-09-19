#!/bin/bash

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
    if [ "$(which "$2" | grep -c "not found")" -ge 1 ]; then
        wget -O package.deb "$3"
        sudo dpkg -i package.deb
        rm package.deb
    else
        info "$1 is already installed, skipping..."
    fi
}

