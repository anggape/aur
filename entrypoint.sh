#!/usr/bin/env zsh

set -e

if [ -d "${YAY_CACHE_DIR}" ]; then
    mkdir -p ~${BUILDER_USER}/.cache
    sudo -u ${BUILDER_USER} cp "${YAY_CACHE_DIR}" ~${BUILDER_USER}/.cache/yay -r
fi

sudo -u ${BUILDER_USER} yay -Syu --norebuild --noconfirm $(cat aur-packages)

sudo cp ~${BUILDER_USER}/.cache/yay ${YAY_CACHE_DIR} -r

sudo mkdir -p output

sudo repo-add output/ape.db.tar.gz ${YAY_CACHE_DIR}/**/*.pkg.tar.zst
