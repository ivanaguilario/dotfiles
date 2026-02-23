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
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias ls='eza -l --icons=auto --group-directories-first --git --header'
alias lt='eza -l --icons=auto --group-directories-first --git --header --tree --level=10'

tmux-dev() {
    local session_name="${1:-dev}"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach -t "$session_name"
        return
    fi

    tmuxinator start dev -n "$session_name"
}
