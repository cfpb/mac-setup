#!/bin/bash

install_nvm() {
    echo "$(tput setaf 7)$(tput setab 6)...Installing nvm$(tput sgr 0)"

    # Install NVM (Node Version Manager).
    # https://github.com/nvm-sh/nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

    echo "# Node and NVM" >> ${HOME}/.zshenv
    echo export NVM_DIR="${HOME}/.nvm" >> ${HOME}/.zshenv
    cat <<EOT >> ${HOME}/.zshenv
if [ -s "\$NVM_DIR/nvm.sh" ]; then
    source "\$NVM_DIR/nvm.sh"
fi
EOT
}

install_node() {
    echo "$(tput setaf 7)$(tput setab 6)...Installing Node LTS$(tput sgr 0)"

    # Export necessary environment variable for use in this script.
    export NVM_DIR="${HOME}/.nvm"

    # Initialize NVM for this script to be able to use it.
    if [ -s "$NVM_DIR/nvm.sh" ]; then
      source "$NVM_DIR/nvm.sh"
    fi

    # Install the latest LTS (long-term support) release of Node and activate it.
    nvm install lts/*
}

install_yarn() {
    echo "$(tput setaf 7)$(tput setab 6)...Installing yarn$(tput sgr 0)"

    # Install the Yarn package manager.
    # https://yarnpkg.com/

    # This will automatically add it to the PATH by appending .bashrc.
    curl -o- -L https://yarnpkg.com/install.sh | bash

    # Add it to the .zshenv
    export PATH="${HOME}/.yarn/bin:${HOME}/.config/yarn/global/node_modules/.bin:${PATH}" >> ${HOME}/.zshenv

    # Update path for this script to be able to access the yarn command.
    export PATH="${HOME}/.yarn/bin:${HOME}/.config/yarn/global/node_modules/.bin:${PATH}"

    # Install global Node packages.
    echo "$(tput setaf 3)$(tput setab 4)...Installing common global packages$(tput sgr 0)"
    yarn global add yo generator-cf generator-node snyk
}

printf "\n\n$(tput bold)$(tput setaf 7)$(tput setab 6)Setting up Node$(tput sgr 0)\n"
install_nvm 
install_node 
install_yarn 
