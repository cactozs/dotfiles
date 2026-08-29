alias nix-conf="doas hx /etc/nixos/configuration.nix"
alias fire-theme="hx .config/mozilla/firefox/kcwx1a7u.default/chrome/userChrome.css"

# Цвета (Gruvbox, 256-color)
RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'

# Gruvbox palette (xterm-256)
G_FG='\[\e[38;5;223m\]'      # fg1  #ebdbb2
G_RED='\[\e[38;5;124m\]'      # red     #cc241d
G_GREEN='\[\e[38;5;143m\]'    # green   #98971a
G_YELLOW='\[\e[38;5;172m\]'   # yellow  #d79921
G_BLUE='\[\e[38;5;66m\]'      # blue    #458588
G_AQUA='\[\e[38;5;72m\]'      # aqua    #689d6a
G_ORANGE='\[\e[38;5;166m\]'   # orange  #d65d0e

parse_git() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch
    branch=$(git branch --show-current)

    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        printf " \001\e[38;5;172m\002*\001\e[0m\002 \001\e[38;5;66m\002%s\001\e[0m\002" "$branch"
    else
        printf " \001\e[38;5;143m\002✓\001\e[0m\002 \001\e[38;5;66m\002%s\001\e[0m\002" "$branch"
    fi
}

PS1="${G_GREEN}\u${RESET}@${G_BLUE}\h${RESET}:${G_YELLOW}\w${RESET}\$(parse_git) ${G_ORANGE}\A${RESET} \$ "
PROMPT_COMMAND='printf "\n"'

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
