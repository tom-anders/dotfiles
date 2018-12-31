set -x DOTFILES $HOME/.dotfiles/
if [ (hostname) = 'tom-linux' ]

    fortune | cowsay
    
    set -x PATH /home/tom/.cargo/bin /home/tom/.local/bin /opt/clion-2017.2.2/bin /home/tom/Downloads/i3-vim-focus/i3-vim-focus/target/release $PATH
    set -x LD_LIBRARY_PATH /home/tom/adolc_base/lib64 /home/tom/Downloads/Ipopt/lib $LD_LIBRARY_PATH 
    set -x LIBRARY_PATH /home/tom/adolc_base/lib64 /home/tom/Downloads/Ipopt/lib $LIBRARY_PATH 
    set -x EDITOR nvim

    cat /home/tom/.cache/wal/sequences
end

source $DOTFILES/fish/.fishalias

#fish_vi_key_bindings
set -U fish_key_bindings fish_vi_key_bindings #alt-e or alt-v to edit in vim
function fish_mode_prompt ; end

#Theme: omf install shellder
