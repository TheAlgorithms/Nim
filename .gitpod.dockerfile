FROM gitpod/workspace-full-vnc

RUN curl https://nim-lang.org/choosenim/init.sh -sSf -o install_nim.sh \
    && chmod +x ./install_nim.sh \
    && ./install_nim.sh -y \
    && rm install_nim.sh \
    && echo "export PATH=/home/$(whoami)/.nimble/bin:\$PATH" >> ~/.bashrc
