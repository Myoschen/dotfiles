# -------------------- #
# environment variable
# -------------------- #

export GPG_TTY=$(tty)
export LC_ALL="en_US.UTF-8"

# -------------------- #
# homebrew
# -------------------- #

export PATH="/opt/homebrew/bin:$PATH"

# -------------------- #
# zsh plugin
# -------------------- #

source ~/p/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/p/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/p/zsh-z/zsh-z.plugin.zsh

# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"

# https://thevaluable.dev/zsh-completion-guide-examples/
zstyle ':completion:*' menu select
zstyle ':completion:*:messages' format '%F{blue}%d%f'
zstyle ':completion:*:warnings' format '%F{red}no matches found%f'
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# -------------------- #
# nvm
# -------------------- #

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# -------------------- #
# pnpm
# -------------------- #

export PNPM_HOME="/Users/myos/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# -------------------- #
# bun
# -------------------- #

# bun completions
[ -s "/Users/myos/.bun/_bun" ] && source "/Users/myos/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# -------------------- #
# starship prompt
# -------------------- #

eval "$(starship init zsh)"

# -------------------- #
# fzf
# -------------------- #

source <(fzf --zsh)

# -------------------- #
# bat
# -------------------- #

export BAT_THEME="Visual Studio Dark+"

# -------------------- #
# alias
# -------------------- #

alias pn="pnpm"
alias g="git"
alias j="just"

# -------------------- #
# directory
# - ~/p for zsh plugins
# - ~/r for repos
# -------------------- #

function p() {
  cd ~/p/$1
}

function r() {
  cd ~/r/$1
}

# -------------------- #
# function
# -------------------- #

function reload_zsh() {
  source ~/.zshrc
}

# for react native
function open_uri() {
  npx uri-scheme open $1 --ios
}