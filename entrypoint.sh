#!/usr/bin/env zsh

# exit on error
set -e

# run as builder alias
alias builder="sudo -u ${BUILDER_USER}"

# configure git
git config --global --add safe.directory ${GITHUB_WORKSPACE}
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

# create git tag for release
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
        git tag "${RELEASE_TAG}"
    fi
}
create_tag

# change working directory to builder home
pushd ~${BUILDER_USER}
{
    # create required directory
    builder mkdir -p .config/pacman .cache

    # copy makepkg.conf
    builder cp ${GITHUB_WORKSPACE}/makepkg.conf .config/pacman/makepkg.conf

    # copy yay cache
    if [ -d "${GITHUB_WORKSPACE}/${YAY_CACHE_DIR}" ]; then
        builder cp "${GITHUB_WORKSPACE}/${YAY_CACHE_DIR}" .cache/yay -r
    fi

    # installing yay
    builder git clone https://aur.archlinux.org/yay.git
    pushd $_
    builder makepkg -sri --needed --noconfirm
    popd

    # install aur packages
    builder yay -Syu $(cat "${GITHUB_WORKSPACE}/aur-packages") --norebuild --noconfirm --noredownload

    # copy yay cache to github workspace
    cp .cache/yay ${GITHUB_WORKSPACE}/${YAY_CACHE_DIR} -r
}
popd #~${BUILDER_USER}

# create pacman repository
mkdir -p output
repo-add output/ape.db.tar.gz ${YAY_CACHE_DIR}/**/*.pkg.tar.zst
