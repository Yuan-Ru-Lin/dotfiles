export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="TheOne"
plugins=(git zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

source $HOME/.local/share/zshrc_local.sh
export PATH="$HOME/.local/bin:$PATH"

export EDITOR=nvim
alias vim="nvim"

if [ -n "$SSH_CONNECTION" ]; then
    unset SSH_ASKPASS
    unset GIT_ASKPASS
fi
