#!/bin/bash
set -e
ROOT_PATH=$(pwd -P)

main() {
    downloader --check

    get_arch
    ARCH="$RETVAL"

    setup_git
    install_homebrew
    install_languages
    install_shell
}

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

get_arch() {
    local _ostype _cputype

    if [ "$OSTYPE" == "linux-gnu" ]; then
        _ostype=unknown-linux-gnu
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        _ostype=apple-darwin
    else
        err "OS $OSTYPE currently unsupported"
    fi

    _cputype=$(uname -m)
    [ $_cputype == "x86_64" ] || [ $_cputype == "arm64" ] || err "CPU $_cputype currently unsupported"

    RETVAL=$_cputype-$_ostype
}

setup_git() {
    info "setting up git"
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.com commit
    git config --global alias.st status
    # git config --global credential.helper osxkeychain
    # git config --global http.postBuffer 157286400

    # Updated git requires a way to resolve divergent, this makes it so divergent branch pulls
    # will only fast foward.  A diveragent branch will fail.  A normal thing to do is to pull a
    # into your working copy, such as "git pull origin master".  A divergence can occur if the
    # remote was force pushed with a missing ancestor from your local copy.
    git config --global pull.ff only

    if [ -z "$(git config --global --get user.email)" ]; then
        echo "Git user.name:"
        read -r user_name
        echo "Git user.email:"
        read -r user_email
        git config --global user.name "$user_name"
        git config --global user.email "$user_email"
    fi
}

install_shell() {
    # Settings for zsh plugins are in .zshrc
    brew install --cask iterm2
    brew tap homebrew/cask-fonts
    brew install \
        zsh-syntax-highlighting zsh-autosuggestions \
        romkatv/powerlevel10k/powerlevel10k \
        font-input font-jetbrains-mono-nerd-font || true


    # mkdir -p ~/.config
    # sym_link $ROOT_PATH/zsh/.zshrc ~/.zshrc
    # sym_link $ROOT_PATH/zsh/.zfuncs ~/.zfuncs
    # sym_link $ROOT_PATH/zsh/.zcustom ~/.zcustom;
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}

install_homebrew() {
    if ! which /opt/homebrew/bin/brew >/dev/null 2>&1; then
        info "Installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
    eval $(/opt/homebrew/bin/brew shellenv)
}

install_languages() {
    brew install node nvm yarn || true
    # brew install go lua node nvm yarn luarocks || true
}


sym_link() {
    if [[ -f $2 ]]; then
        if [ -e "$2" ]; then
            if [ "$(readlink "$2")" = "$1" ]; then
                info "Symlink skipped $1"
                return 0
            else
                mv "$2" "$2.bak"
                info "Symlink moved $2 to $2.bak"
            fi
        fi
    fi
    ln -sf "$1" "$2"
    info "Symlinked $1 to $2"
}

## Utils

info() {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

ok() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

err() {
    printf "\r\033[2K  [\033[0;31mERR\033[0m] $1\n"
    exit
}

ensure() {
    if ! "$@"; then err "command failed: $*"; fi
}

require() {
    if ! check_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

append_not_exists() {
    if [ -f "$2" ] && grep -q "$1" "$2"; then
        info "PATH exists in \'$2\'"
        return
    fi

    info "\'$1\' >> \'$2\'"
    echo "$1" >>"$2"
}

main "$@"
