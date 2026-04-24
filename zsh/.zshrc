export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    dotenv
    gh
    git
    golang
    gpg-agent
    podman
    ssh
)

HOMEBREW_PREFIX=/opt/homebrew

source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source $ZSH/oh-my-zsh.sh

alias ls='eza -l --icons=auto --group-directories-first --git --header'
alias lt='eza -l --icons=auto --group-directories-first --git --header --tree --level=10'
alias ws-reset='$HOME/.config/.scripts/workspace-reset.sh'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Go
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin

if [ -f "$HOME/.config/opencode/opencode.local.json" ]; then
    export OPENCODE_CONFIG="$HOME/.config/opencode/opencode.local.json"
fi

tmux-dev() {
    local session_name="${1:-dev}"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach -t "$session_name"
        return
    fi

    tmuxinator start dev -n "$session_name"
}
