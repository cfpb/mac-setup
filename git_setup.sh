#!/bin/bash


install_git() {
    echo "$(tput setaf 7)$(tput setab 1)...Installing Git$(tput sgr 0)"

    brew install git git-secrets
}

configure_git() {
    echo "$(tput setaf 7)$(tput setab 1)...Configuring git$(tput sgr 0)"

    # Add global Git config for .gitmessage.
    git config --global commit.template $HOME/.gitmessage
}

configure_git_secrets() {
    echo "$(tput setaf 7)$(tput setab 1)...Configuring git-secrets$(tput sgr 0)"

    # Install git-secrets hooks.
    # https://github.com/awslabs/git-secrets
    git secrets --install $HOME/.git-templates/git-secrets
    git config --global init.templateDir $HOME/.git-templates/git-secrets
    git secrets  --add-provider -- egrep -v '^$|^#' $HOME/.secret_patterns
}

if [ -d "${HOME}/homebrew" ]; then
    export PATH="${HOME}/homebrew/bin:${PATH}"

    printf "\n\n$(tput bold)$(tput setaf 7)$(tput setab 1)Setting up Git$(tput sgr 0)\n"
    install_git 
    configure_git 
    configure_git_secrets 
else 
    echo "Homebrew was not found. Please ensure that Homebrew is installed or use the `homebrew_setup.sh` script."
    exit 1
fi
