export DOTFILES=$HOME/.dotfiles/

if [ $(hostname) = 'arch-laptop' ]; then

    fortune linuxcookie sherlock chucknorris paradoxum matrix houseofcards starwars education humorists linux science sports portal2 medicine literature wisdom ascii-art computers breakingbad archlinux news | cowsay

    # If you come from bash you might have to change your $PATH.
    export PATH=$HOME/.local/bin:/opt/intel/bin:$PATH
    export LD_LIBRARY_PATH=/home/tom/adolc_base/lib64:/usr/local/lib:$LD_LIBRARY_PATH
    export LIBRARY_PATH=/home/tom/adolc_base/lib64:/usr/local/lib:$LIBRARY_PATH
    source $HOME/.cargo/env
    export EDITOR=nvim

    # Path to your oh-my-zsh installation.
    export ZSH=/home/tom/.oh-my-zsh

    # Import colorscheme from 'wal'
    # (cat /home/tom/.cache/wal/sequences &)

    # Autojump
    [[ -s /home/tom/.autojump/etc/profile.d/autojump.sh ]] && source /home/tom/.autojump/etc/profile.d/autojump.sh
    autoload -U compinit && compinit -u

    alias presentation='xrandr --output eDP-1 --mode 1920x1080 --output HDMI-1 --right-of eDP-1 --mode 1920x1080 && ~/.config/polybar/launch.sh'
    alias presentationOff='xrandr --output HDMI-1 --off'

    eval "$(fasd --init auto)"
fi

if [[ $(hostname) = 'tom-linux' ]]; then

    fortune | cowsay
    
    export PATH=/home/tom/.cargo/bin:/home/tom/.local/bin:/opt/clion-2017.2.2/bin:/home/tom/Downloads/i3-vim-focus/i3-vim-focus/target/release:$PATH
    export LD_LIBRARY_PATH=/home/tom/adolc_base/lib64:$LD_LIBRARY_PATH
    export LIBRARY_PATH=/home/tom/adolc_base/lib64:$LIBRARY_PATH
    export EDITOR=nvim

    # Path to your oh-my-zsh installation.
    export ZSH=/home/tom/.oh-my-zsh

    (cat /home/tom/.cache/wal/sequences)
    #
    #for autojump
    # [[ -s /home/tom/.autojump/etc/profile.d/autojump.sh ]] && source /home/tom/.autojump/etc/profile.d/autojump.sh
    # autoload -U compinit && compinit -u

    #fasd init
    eval "$(fasd --init auto)"
fi

if [[ $(hostname) = cmspool* ]]; then #Double braces for * to work
    export ZSH=/upb/users/t/tap/profiles/unix/imt/.oh-my-zsh
    $DOTFILES/scripts/configKeyboard.sh 
    unsetopt correct #disable annoying autocorrect
    eval "$(fasd --init auto)"
fi

if [[ $(hostname) = fe1 ]] || [[ $(hostname) = fe-402-1.local ]] || [[ $(hostname) = fe2 ]]; then #Double braces for * to work
    export TERM="xterm-256color"
    export ZSH=/upb/departments/pc2/users/t/tap/.oh-my-zsh
    export PATH=/upb/departments/pc2/users/t/tap/bin:$PATH
    export LD_LIBRARY_PATH=/upb/departments/pc2/scratch/tap/gcc-7.2.0/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=/upb/departments/pc2/scratch/tap/gcc-7.2.0/lib64:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=/upb/departments/pc2/scratch/tap/boost_1_65_1/stage/lib:$LD_LIBRARY_PATH
fi

if [[ $(hostname) = fe1 ]] || [[ $(hostname) = fe-402-1.local ]] || [[ $(hostname) = fe2 ]]; then #Double braces for * to work
    #Vim mode
    bindkey -v    
    bindkey "^[[A" history-search-backward
    bindkey "^[[B" history-search-forward
else 
    plugins=(git zsh-syntax-highlighting vi-mode history-substring-search extract archlinux z zsh-autosuggestions)
    ZSH_THEME="refined"
    source $ZSH/oh-my-zsh.sh
fi

setopt HIST_FIND_NO_DUPS
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE='true'

source $DOTFILES/zsh/.zshalias

