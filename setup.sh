#!/usr/bin/bash

set -e

PREFIX=${HOME}/.local
SRC=${HOME}/sources

if [ -z "$(grep "llvm-toolchain" /etc/apt/sources.list)" ]; then
    echo -e '\ndeb http://apt.llvm.org/focal/ llvm-toolchain-focal-18 main' |\
        sudo tee -a /etc/apt/sources.list > /dev/null
    echo 'deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-18 main' |\
        sudo tee -a /etc/apt/sources.list > /dev/null
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
fi

sudo apt update && sudo apt upgrade

sudo apt install gcc python3-dev libncurses-dev make ripgrep fd-find curl tmux \
    clangd-18 batcat

if [ ! -d "${HOME}/.fzf" ]; then
    git clone https://github.com/junegunn/fzf ${HOME}/.fzf
    pushd ${HOME}/.fzf
    ./install --bin
    [ -z "$(grep "\.fzf\.bash" ${HOME}/.bashrc)" ] && \
        echo -e '\n[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> ${HOME}/.bashrc
    popd
fi

if [ ! -f "${PREFIX}/bin/vim" ]; then
    git clone https://github.com/vim/vim ${SRC}/vim
    pushd ${SRC}/vim
    git checkout v9.1.0818
    ./configure --prefix=${PREFIX} \
        --enable-fail-if-missing \
        --enable-multibyte \
        --enable-python3interp=yes \
        --with-features=huge
    make -j8
    make install

    sudo apt purge vim vim-common vim-runtime vim-tiny

    popd
fi

mkdir -p ${HOME}/.vim/tmp

if [ ! -f "${HOME}/.vim/autoload/plug.vim" ]; then
    curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

cp vimrc        ${HOME}/.vimrc
cp tmux.conf    ${HOME}/.tmux.conf
cp fzf.bash     ${HOME}/.fzf.bash
cp bash_aliases ${HOME}/.bash_aliases

ln -s /usr/bin/batcat ${PREFIX}/bin/bat

echo "Please source profile and bashrc, 'source ~/.profile && source ~/.bashrc'"
