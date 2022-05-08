#!/usr/bin/env zsh

if [ -d "yay-cache" ]; then
    mkdir -p ~${BUILDER_USER}/.cache
    sudo -u ${BUILDER_USER} mv "yay-cache" ~${BUILDER_USER}/.cache/yay
fi

sudo -u ${BUILDER_USER} yay -Syu --noconfirm - <aur-packages

cp ~${BUILDER_USER}/.cache/yay ${GITHUB_WORKSPACE}/yay-cache
