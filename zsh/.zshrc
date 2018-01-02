export DOTFILES=$HOME/.dotfiles/zsh

if [ $(hostname) = 'arch-laptop' ]; then

    fortune linuxcookie sherlock chucknorris paradoxum matrix houseofcards starwars education humorists linux science sports portal2 medicine literature wisdom ascii-art computers breakingbad archlinux news | cowsay

    # If you come from bash you might have to change your $PATH.
    export PATH=$HOME/.local/bin:/opt/intel/bin:$PATH
    source $HOME/.cargo/env

    # Path to your oh-my-zsh installation.
    export ZSH=/home/tom/.oh-my-zsh

    eval $(thefuck --alias)

    # Import colorscheme from 'wal'
    (cat /home/tom/.cache/wal/sequences &)

    # Autojump
    [[ -s /home/tom/.autojump/etc/profile.d/autojump.sh ]] && source /home/tom/.autojump/etc/profile.d/autojump.sh
fi

ZSH_THEME="refined"

plugins=(git zsh-syntax-highlighting vi-mode history-substring-search extract archlinux)

source $ZSH/oh-my-zsh.sh

source $DOTFILES/.zshalias

