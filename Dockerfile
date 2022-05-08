FROM archlinux:base-devel

COPY . .

ENV BUILDER_USER=builder

RUN pacman -Syu --noconfirm zsh git

RUN useradd -m ${BUILDER_USER}

RUN echo "${BUILDER_USER} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

USER ${BUILDER_USER}

WORKDIR /home/${BUILDER_USER}

RUN git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -sri --needed --noconfirm

ENTRYPOINT [ "./entrypoint.sh" ]
