# -------------------- #
# environment variable
# -------------------- #
export PATH="/opt/homebrew/bin:$PATH"
export PNPM_HOME="/Users/r/Library/pnpm"


# -------------------- #
# zsh plugin
# -------------------- #
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/autojump/autojump.zsh
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
# - wip
# -------------------- #

# function i() {
#   cd ~/i/$1
# }

# function repros() {
#   cd ~/r/$1
# }

# function forks() {
#   cd ~/f/$1
# }