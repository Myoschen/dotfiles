#!/bin/bash

# shell script style guide
# see https://google.github.io/styleguide/shellguide.html

set -e # the script exits immediately on encountering any errors
ROOT_PATH=$(pwd -P) # the absolute path to the current working directory

# entry
main() {
    downloader --check

    get_arch
    ARCH="$RETVAL"

    init

    install_brew
    install_uses
    install_plugins
    
    setup_git
}

# check the download tools available on your system (curl or wget)
downloader() {
    local _dld
    
    if check_cmd curl; then
        _dld=curl
    elif check_cmd wget; then
        _dld=wget
    else
        _dld='curl or wget' # to be used in error message of require
    fi

    if [ "$1" = --check ]; then
        require "$_dld"
    elif [ "$_dld" = curl ]; then
        curl --proto '=https' --tlsv1.2 --silent --show-error --fail --location "$1" --output "$2"
    elif [ "$_dld" = wget ]; then
        wget --https-only --secure-protocol=TLSv1_2 "$1" -O "$2"
    fi
}

# get os (linux or mac) and cpu (x86_64 or arm64)
get_arch() {
    local _ostype _cputype

    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        _ostype=unknown-linux-gnu
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        _ostype=apple-darwin
    else
        err "os $OSTYPE currently unsupported"
    fi

    _cputype=$(uname -m)
    [[ $_cputype == "x86_64" || $_cputype == "arm64" ]] || err "cpu $_cputype currently unsupported"

    RETVAL=$_cputype-$_ostype
}

# initialize (create directories)
init() {
    info "initializing"

    # for configs
    mkdir -p $HOME/.config
    
    # for git repository
    mkdir -p $HOME/r

    # for zsh plugins
    mkdir -p $HOME/p
}

# install homebrew
install_brew() {
    if ! which /opt/homebrew/bin/brew >/dev/null 2>&1; then
        info "installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval $(/opt/homebrew/bin/brew shellenv)
}

# install the tools I use
install_uses() {
    # starship
    curl -sS https://starship.rs/install.sh | sh

    # git
    brew install git || true

    # nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

    # pnpm
    curl -fsSL https://get.pnpm.io/install.sh | sh -

    # bun
    curl -fsSL https://bun.sh/install | bash

    # yarn
    # brew install yarn || true

    # install rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # app
    brew install --cask iterm2 visual-studio-code docker expo-orbit orbstack arc || true

    # font
    brew install font-jetbrains-mono font-input font-meslo-lg-nerd-font font-sarasa-gothic || true

    # util
    # brew install just tokei fastfetch || true
    
    # sym_link $ROOT_PATH/configs/.zshrc $HOME/.zshrc
    # sym_link $ROOT_PATH/configs/starship.toml $HOME/.config/starship.toml
    copy_file $ROOT_PATH/configs/.zshrc $HOME/.zshrc
    copy_file $ROOT_PATH/configs/starship.toml $HOME/.config/starship.toml
}

# install zsh plugin
install_plugins() {
    info "installing zsh plugins"

    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/p/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/p/zsh-syntax-highlighting
    git clone https://github.com/agkozak/zsh-z $HOME/p/zsh-z
}

# setup git username and email
setup_git() {
    info "setting up git"

    copy_file $ROOT_PATH/configs/.gitconfig $HOME/.gitconfig

    if [ -z $(git config --global --get user.name) ]; then
        echo "your git user.name:"
        read -r user_name
        git config --global user.name "$user_name"
    fi

    if [ -z "$(git config --global --get user.email)" ]; then
        echo "your git user.email:"
        read -r user_email
        git config --global user.email "$user_email"
    fi
}

# create symbolic link
sym_link() {
    if [[ -f $2 ]]; then
        if [ -e "$2" ]; then
            if [ "$(readlink "$2")" = "$1" ]; then
                info "symlink skipped $1"
                return 0
            else
                mv "$2" "$2.bak"
                info "symlink moved $2 to $2.bak"
            fi
        fi
    fi
    ln -sf "$1" "$2"
    info "symlinked $1 to $2"
}

# copy file
copy_file() {
    # no target file path passed
    if [ -z "$1" ] || [ -z "$2" ]; then
        info "usage: copy_file <source> <target>"
        return 0
    fi

    # check source file
    if [ ! -f "$1" ]; then
        err "source '$1' does not exist"
    fi

    # check target file
    if [ -f "$2" ]; then
        mv "$2" "$2.bak"
        info "backing up '$2' to '$2.bak'"
    fi

    cp "$1" "$2"

    if [ $? -eq 0 ]; then
        ok "file '$1' successfully copied to '$2'"
        return 0
    else 
        err "failed to copy '$1' to '$2'"
    fi
}

# `\033[2K` clear entire line
# `\033[0m` reset text format

info() {
    # `\033[00;34m` set text color to blue
    printf "\r  [ \033[00;34mINFO\033[0m ] $1\n"
}

ok() {
    # `\033[00;32m` set text color to green
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# display an error message and terminate script execution immediately
err() {
    # `\033[0;31m` set text color to red
    printf "\r\033[2K  [\033[0;31mERR\033[0m] $1\n"
    exit
}

# ensure that the specified command is executed successfully
ensure() {
    if ! "$@"; then err "command failed: $*"; fi
}

# make sure the commands the script depends on exist
require() {
    if ! check_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

# check if the command exists
check_cmd() {
    # `> /dev/null 2>&1` discard all output (stdout=1, stderr=2)
    # see https://ibookmen.blogspot.com/2010/11/unix-2.html
    command -v "$1" > /dev/null 2>&1
}

# if the content does not exist, append it to the end of the file
append_not_exists() {
    if [ -f "$2" ] && grep -q "$1" "$2"; then
        info "path exists in \'$2\'"
        return
    fi

    info "\'$1\' >> \'$2\'"
    echo "$1" >> "$2"
}

# `$@` all parameters passed to the function
main "$@"
