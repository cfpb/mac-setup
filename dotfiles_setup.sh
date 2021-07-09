#!/bin/bash

printf "\n\n$(tput bold)$(tput setaf 7)$(tput setab 2)Creating CFPB standard dotfiles$(tput sgr 0)\n"
echo "$(tput setaf 7)$(tput setab 2)Note: Existing files will be backed up in the same location with a suffix of the date.$(tput sgr 0)"

rsync -abq --suffix=_`date +"%Y%m%d_%H%M"` ./dotfiles/ $HOME/
