# Add pipx, Yarn, and userland Homebrew to the PATH
# =================================================
export PATH="${HOME}/.local/bin:${HOME}/.yarn/bin:${HOME}/.config/yarn/global/node_modules/.bin:${HOME}/homebrew/bin:${PATH}"


# Initialize pyenv
# ================

## Export necessary environment variables
export PYENV_ROOT="${HOME}/.pyenv"
export WORKON_HOME="${HOME}/.virtualenvs"

## Run pyenv init command
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

## Init pyenv-virtualenvwrapper
pyenv virtualenvwrapper_lazy


# Initialize nvm
# ==============

## Export necessary environment variable
export NVM_DIR="${HOME}/.nvm"

# Run nvm init script
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi


# OPTIONAL: Source other dotfiles in your home directory
# ======================================================
#
# Uncomment the lines below and modify the list in the for loop to include the
# dotfiles you want to be sourced.
#
# for file in $HOME/.{exports,bash_prompt,aliases}; do
#   if [ -s "$file" ]; then
#     source "$file"
#   fi
# done
# unset file
