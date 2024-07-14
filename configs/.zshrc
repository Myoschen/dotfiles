# -------------------- #
# environment variable
# -------------------- #
export PATH="/opt/homebrew/bin:$PATH"
export PNPM_HOME="/Users/r/Library/pnpm"
export GPG_TTY=$(tty)
export LC_ALL="en_US.UTF-8"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# -------------------- #
# zsh plugin
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
alias code="code --profile Work"


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