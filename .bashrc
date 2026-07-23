alias nix-conf="HOME=$HOME doas hx /etc/nixos/configuration.nix"

# Цвета
RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
CYAN='\[\e[36m\]'

parse_git() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch
    branch=$(git branch --show-current)

    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        printf " \001\e[33m\002*\001\e[0m\002 \001\e[34m\002%s\001\e[0m\002" "$branch"
    else
        printf " \001\e[32m\002✓\001\e[0m\002 \001\e[34m\002%s\001\e[0m\002" "$branch"
    fi
}

PS1="${GREEN} \u${RESET}@${CYAN}\h${RESET}:${BLUE}\w${RESET}\$(parse_git) ${YELLOW}\A${RESET} \$ "
PROMPT_COMMAND='printf "\n"'

export PATH="$HOME/.local/bin:$PATH"
