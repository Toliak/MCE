FROM debian:buster

RUN apt-get update --allow-releaseinfo-change -y && \
    apt-get install -y git        \
                       zsh        \
                       powerline  \
                       tmux       \
                       vim        \
                       curl       \
                       xclip      \
                       xsel
