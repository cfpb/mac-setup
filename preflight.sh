#!/bin/bash

check_for_xcode() {
    printf "$(tput setaf 2)Checking for Xcode command-line tools... $(tput sgr 0)"

    # Check to see if the user is on a development Mac by checking whether
    # we can resolve and access DEV and EXT DNS names

    if [ $(xcode-select -p 1>/dev/null;) ]; then
        printf "$(tput setaf 1)X$(tput sgr 0)\n"
        echo "   Unable to find Xcode command-line tools."
        echo "   Please make sure they are installed."
        return 1
    fi

    printf "$(tput setaf 2)✓$(tput sgr 0)\n"
}


run_checks() {
    # Test the resulting status code of our checks
    result=0
    trap 'result=1' ERR

    # Run the checks
    check_for_xcode

    # If any of the checks failed, ask the user if they wish to proceed.
    if [ $result -ne 0 ]; then
        printf "$(tput bold)$(tput setaf 1)There were errors in preflight checks.\nThe setup may fail.\nDo you wish to continue anyway?$(tput sgr 0)"

        while true; do
            read -p "$* [y/n]: " choice
            case $choice in
                [Yy]*)
                    return 0
                    ;;
                [Nn]*)
                    printf "\n$(tput bold)$(tput setaf 1)Please check the issues identified above and try again.$(tput sgr 0)\n"
                    exit 1
                    ;;
            esac
        done
    fi
}


printf "\n\n$(tput bold)$(tput setaf 7)$(tput setab 2)Starting preflight checks...$(tput sgr 0)\n"
run_checks
