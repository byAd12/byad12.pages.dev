#!/bin/bash

# -- byad12.pages.dev/parrot.sh
# -- Script hecho por byAd12.pages.dev

##############################################################
# ACTUALIZAR E INSTALAR PAQUETES
##############################################################
apt update
apt install -y bat openvpn neofetch htop micro cowsay
clear

##############################################################
# AÑADIR ALIAS
##############################################################
anadir_alias() {
    local alias="$1"
    local comando="$2"
    if ! grep -q "alias $alias=" ~/.bashrc; then
        echo "alias $alias=\"$comando\"" >> ~/.bashrc

        echo "[+] alias $alias='$comando' >> ~/.bashrc"
    else
        echo "[!] alias $alias='$comando' >> ~/.bashrc"
    fi
}

anadir_alias nano "micro"
anadir_alias cat "batcat"
anadir_alias vpn "sudo /usr/sbin/openvpn --config"
anadir_alias py_http_8000 'sudo python3 -m http.server 8000'

##############################################################
# AÑADIR COMANDO DE INICIO
##############################################################
anadir_comando() {
    local comando="$1"
    if ! grep -q "$comando" ~/.bashrc; then
        echo "$comando" >> ~/.bashrc
        echo "[+] $comando >> ~/.bashrc"
    else
        echo "[!] $comando >> ~/.bashrc"
    fi
}

anadir_comando "neofetch"

##############################################################
# DIBUJO
##############################################################
/usr/games/cowsay -f tux byAd12
