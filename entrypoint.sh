#!/usr/bin/env zsh

set -e

if [ -d "yay-cache" ]; then
    mkdir -p ~${BUILDER_USER}/.cache
    sudo -u ${BUILDER_USER} cp "yay-cache" ~${BUILDER_USER}/.cache/yay -r
fi

sudo -u ${BUILDER_USER} yay -Syu --noconfirm $(cat aur-packages)

sudo cp ~${BUILDER_USER}/.cache/yay yay-cache -r
