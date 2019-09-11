# This is the first file that Bash on macOS looks for after executing the
# system default dotfiles.

# We keep all major functionality in .bashrc and source it here, per guidance
# in the following articles:
# - http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
# - https://scriptingosx.com/2017/04/about-bash_profile-and-bashrc-on-macos/

if [ -s $HOME/.bashrc ]; then
  source $HOME/.bashrc
fi
