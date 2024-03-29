export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

ZSH_THEME="TheOne"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source $HOME/.local/share/zshrc_local.sh
export PATH="$HOME/.local/bin:$PATH"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ -n "$SSH_CONNECTION" ]; then
    unset SSH_ASKPASS
    unset GIT_ASKPASS
fi

alias vim="nvim"
