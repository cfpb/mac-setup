#!/bin/bash

# Homebrew and shell variables
BREW_CASK_INSTALL_DIR="BrewApps" 
PATH_VAR="PATH=${HOME}/homebrew/bin:\${PATH}"
HOMEBREW_CASK_VAR="HOMEBREW_CASK_OPTS=\"--appdir=${HOME}/${BREW_CASK_INSTALL_DIR}\""
HOMEBREW_PREFIX_VAR="HOMEBREW_PREFIX=${HOME}/homebrew/bin"

homebrew_found() { 
    read -n1 -p "Would you like to reset your env? [y/N]" reset
    case $reset in
        y|Y) {
            if [ -f ".zshrc" ]; then
                    grep -v "homebrew" .zshrc > temp && mv temp .zshrc
                    printf "\nCleaned up .zshrc\n"
            fi
            if [ -f ".zshenv" ]; then
                grep -v "homebrew" .zshenv > temp1 && mv temp1 .zshenv
                printf "\nCleaned up .zshenv\n"
            fi
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
                install_homebrew
        } ;;
        n|N) printf "\nNot installing homebrew && exiting installer\n";;
        *) printf "\nInvalid input try again\n"; homebrew_found;;
    esac
}

install_homebrew() { 
    echo "$(tput setaf 3)$(tput setab 0)...Installing Homebrew$(tput sgr 0)"

    mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
    mkdir ${HOME}/${BREW_CASK_INSTALL_DIR}
    echo "# Homebrew" >> ${HOME}/.zshenv
    echo export ${PATH_VAR} >> ${HOME}/.zshenv
    echo export ${HOMEBREW_CASK_VAR} >> ${HOME}/.zshenv
    echo export ${HOMEBREW_PREFIX_VAR} >> ${HOME}/.zshenv
    
    finally
}

finally(){
    printf "\nYour \"brew cask install <application>\" will be found in ${HOME}/${BREW_CASK_INSTALL_DIR}\n"
    printf "Which we have opened up now, please drag the folder to your favorites or dock\n"
    open ${HOME}/${BREW_CASK_INSTALL_DIR}
}

cd ${HOME}
if [ -d "${HOME}/homebrew" ]; then
    homebrew_found
else 
    printf "\n\n$(tput bold)$(tput setaf 3)$(tput setab 0)Setting up Homebrew$(tput sgr 0)\n"
    install_homebrew
fi
