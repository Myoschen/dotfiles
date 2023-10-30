# -------------------- #
# environment variable
# -------------------- #
export PATH="/opt/homebrew/bin:$PATH"
export PNPM_HOME="/Users/r/Library/pnpm"
export GPG_TTY=$(tty)
export LC_ALL="en_US.UTF-8"

# -------------------- #
# zsh plugin
# - wip
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/p/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/p/zsh-syntax-highlighting
# git clone https://github.com/agkozak/zsh-z ~/p/zsh-z
# -------------------- #
source ~/p/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/p/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/p/zsh-z/zsh-z.plugin.zsh
source $(brew --prefix nvm)/nvm.sh


# -------------------- #
# pnpm
# -------------------- #
export PNPM_HOME="/Users/r/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


# -------------------- #
# starship prompt
# -------------------- #
eval "$(starship init zsh)"


# -------------------- #
# alias
# -------------------- #
alias pn="pnpm"
alias g="git"


# -------------------- #
# directory
# - ~/p zsh plugins
# - ~/r repos
# -------------------- #

function plugins() {
  cd ~/p/$1
}

function repos() {
  cd ~/r/$1
}