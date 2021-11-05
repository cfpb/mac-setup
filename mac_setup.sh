#!/bin/bash

# Fail immediately if any commands fail.
set -e

printf "$(tput bold)$(tput setaf 7)$(tput setab 2)CFPB Mac Setup$(tput sgr 0)\n\n"

# Run our preflight checks to ensure the best chance of success
./preflight.sh

# Install Homebrew, "the missing package manager for macOS".
# https://brew.sh/
./homebrew_setup.sh

# Install Python, pyenv to manage it, and pipx to manage Python utilities
./python_setup.sh

# Install Node, nvm to manage it, and Yarn
./node_setup.sh

# Set up Git and git-secrets
./git_setup.sh

# Apply standard dotfiles, backing up existing files if present.
./dotfiles_setup.sh

printf "\n\n$(tput bold)$(tput setaf 7)$(tput setab 2)Setup complete! Be sure to source ./zshenv or open a new terminal window.$(tput sgr 0)\n"
