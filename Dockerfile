FROM archlinux:base-devel

COPY . .

ENV BUILDER_USER=builder YAY_CACHE_DIR=yay-cache

RUN pacman -Syu --noconfirm zsh git

RUN useradd -m ${BUILDER_USER}

RUN echo "${BUILDER_USER} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

ENTRYPOINT [ "./entrypoint.sh" ]
