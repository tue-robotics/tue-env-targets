#! /usr/bin/env bash

# .vimrc
if [ ! -f ~/.vimrc ]
then
    tue-install-echo "installing a basic vimrc..."
    # install a TU/e .vimrc
    tue-install-cp vimrc ~/.vimrc
fi

# install pathogen for automatic vim plugin loading
if [ ! -d ~/.vim/autoload ]
then
    # install pathogen.vim
    # https://github.com/tpope/vim-pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    wget https://tpo.pe/pathogen.vim -O ~/.vim/autoload/pathogen.vim

    # Now you can install any plugin into a .vim/bundle/plugin-name/ folder
fi

# editorconfig
if [ ! -d ~/.vim/bundle/editorconfig-vim ]
then
    tue-install-echo "installing editorconfig..."
    tue-install-git https://github.com/editorconfig/editorconfig-vim.git --target-dir=~/.vim/bundle/editorconfig-vim
fi

tue-install-system-now vim

# set the default editor to vim
vimdir="/usr/bin/vim.basic"
if [ -f $vimdir ] # only if vim is installed
then
    current=$(update-alternatives --query editor | grep Value | awk '{printf $2}')
    if [ "$current" = "/bin/nano" ]
    then
        tue-install-echo "You are using nano, let's setup vim"
        tue-install-pipe sudo update-alternatives --set editor $vimdir
    fi
fi
