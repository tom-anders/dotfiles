export DOTFILES=$HOME/.dotfiles/

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

    alias presentation='xrandr --output eDP-1 --mode 1920x1080 --output HDMI-1 --right-of eDP-1 --mode 1920x1080 && ~/.config/polybar/launch.sh'
    alias presentationOff='xrandr --output HDMI-1 --off'
fi

if [[ $(hostname) = cmspool* ]]; then #Double braces for * to work
    export ZSH=/upb/users/t/tap/profiles/unix/imt/.oh-my-zsh
    $DOTFILES/scripts/configKeyboard.sh 
    unsetopt correct #disable annoying autocorrect
fi

if [[ $(hostname) = fe1 ]] || [[ $(hostname) = fe-402-1.local ]]; then #Double braces for * to work
    export TERM="xterm-256color"
    export ZSH=/upb/departments/pc2/users/t/tap/.oh-my-zsh
    export PATH=/upb/departments/pc2/users/t/tap/bin:$PATH
    export LD_LIBRARY_PATH=/upb/departments/pc2/scratch/tap/gcc-7.2.0/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=/upb/departments/pc2/scratch/tap/gcc-7.2.0/lib64:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=/upb/departments/pc2/scratch/tap/boost_1_65_1/stage/lib:$LD_LIBRARY_PATH
fi

ZSH_THEME="refined"

plugins=(git zsh-syntax-highlighting vi-mode history-substring-search extract archlinux z)

setopt HIST_FIND_NO_DUPS
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE='true'

source $ZSH/oh-my-zsh.sh

source $DOTFILES/zsh/.zshalias

