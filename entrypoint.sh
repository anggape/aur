#!/usr/bin/env zsh

set -e

sudo git config --global --add safe.directory ${GITHUB_WORKSPACE}

function create_tag() {
    TAG_DATE=$(date '+%Y/%m/%d')
    if [ -z "$1" ]; then
        TAG_ID=0
    else
        TAG_ID=$((TAG_ID + 1))
    fi

    RELEASE_TAG="${TAG_DATE}.${TAG_ID}"

    if [ $(git tag -l "${RELEASE_TAG}") ]; then
        create_tag ${TAG_ID}
    else
        echo "::set-output name=RELEASE_TAG::${RELEASE_TAG}"
        sudo git tag "${RELEASE_TAG}"
    fi
}
create_tag

if [ -d "${YAY_CACHE_DIR}" ]; then
    mkdir -p ~${BUILDER_USER}/.cache
    sudo -u ${BUILDER_USER} cp "${YAY_CACHE_DIR}" ~${BUILDER_USER}/.cache/yay -r
fi

sudo -u ${BUILDER_USER} yay -Syu --norebuild --noconfirm $(cat aur-packages)

sudo cp ~${BUILDER_USER}/.cache/yay ${YAY_CACHE_DIR} -r

sudo mkdir -p output

sudo repo-add output/ape.db.tar.gz ${YAY_CACHE_DIR}/**/*.pkg.tar.zst
