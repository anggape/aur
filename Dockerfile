FROM archlinux:base-devel

COPY . .

ENV BUILDER_USER=builder YAY_CACHE_DIR=yay-cache

RUN pacman -Syu --noconfirm zsh git

RUN useradd -m ${BUILDER_USER}

RUN echo "${BUILDER_USER} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

USER ${BUILDER_USER}

COPY makepkg.conf /home/${BUILDER_USER}/.makepkg.conf

WORKDIR /home/${BUILDER_USER}

RUN git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -sri --needed --noconfirm

ENTRYPOINT [ "./entrypoint.sh" ]
