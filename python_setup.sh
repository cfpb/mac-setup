#!/bin/bash
# Set up Python environment.
# Following the instructions at:
# https://github.com/cfpb/development/blob/master/guides/installing-python.md

# Specify the default version of Python that we use.
export PYTHON3_VER="3.6.9"

install_pyenv() {
    echo "$(tput setaf 3)$(tput setab 4)...Installing pyenv$(tput sgr 0)"

    brew install pyenv pyenv-virtualenv

    echo "# Python and pyenv" >> ${HOME}/.zshenv
    echo export PYENV_ROOT="${HOME}/.pyenv"
    echo export PATH="$PYENV_ROOT/bin:$PATH"
    echo eval "$(pyenv init --path)" >> ${HOME}/.zshenv
    echo eval "$(pyenv virtualenv-init -)" >> ${HOME}/.zshenv

    echo export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init --path)"

}


install_preferred_python() {
    echo "$(tput setaf 3)$(tput setab 4)...Installing Python ${PYTHON3_VER}$(tput sgr 0)"

    # Initialize pyenv for this script to be able to use it.
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv 1>/dev/null 2>&1; then
      eval "$(pyenv init --path)"
    fi

    # Install build requirements for Python
    brew install zlib bzip2

    # Set build flags necessary for Big Sur (see https://github.com/pyenv/pyenv/issues/1740#issuecomment-738749988)
    CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include"
    LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib"
    pyenv install --patch ${PYTHON3_VER} < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch\?full_index\=1)

    # Set as the default global version
    pyenv global ${PYTHON3_VER}
}

install_pipx() {
    echo "$(tput setaf 3)$(tput setab 4)...Installing pipx$(tput sgr 0)"

    ## Install pipx
    brew install pipx
}


if [ -d "${HOME}/homebrew" ]; then
    export PATH="${HOME}/homebrew/bin:${PATH}"

    printf "\n\n$(tput bold)$(tput setaf 3)$(tput setab 4)Setting up Python$(tput sgr 0)\n"
    install_pyenv
    install_preferred_python
    install_pipx
else 
    echo "Homebrew was not found. Please ensure that Homebrew is installed or use the `homebrew_setup.sh` script."
    exit 1
fi

