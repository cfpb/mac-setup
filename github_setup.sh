#!/bin/bash

ssh_key_file="$HOME/.ssh/id_rsa"
plist_file="$HOME/Library/LaunchAgents/org.cfpb.github_setup.plist"
launchd_mode=0
# A very ugly way of getting the path of the script in OSX
script_abs_path=$(cd "$(dirname "$0")"; pwd)"/"$(basename "$0")

# colors for terminal highlighting
color_red=$(tput setaf 1)
color_green=$(tput setaf 2)
color_yellow=$(tput setaf 3)
color_magenta=$(tput setaf 5)
color_reset=$(tput sgr0)

function println_alert {
    echo "${color_red}$1${color_reset}"
}
function print_warning {
    echo -n "${color_yellow}$1${color_reset}"
}
function println_warning {
    echo "${color_yellow}$1${color_reset}"
}
function println_title {
    echo "${color_magenta}$1${color_reset}"
}
function println_normal {
    echo "${color_green}$1${color_reset}"
}

# Trim leading and trailing whitespace.
function trim_str {
    echo -n "$1" | sed 's/^ *//' | sed 's/ *$//'
}

function help {
  echo "Usage:	github_setup.sh [-h] [-l]"
  echo "  -h	help"
  echo "  -l	run in launchd mode, which includes a GUI prompt to start, and disables the launchd script after completion"
}

while getopts "hl" opt; do
  case "$opt" in
  h)
    help
    exit 0
    ;;
  l)
    launchd_mode=1
    ;;
  *)
    help
    exit 1
    ;;
  esac
done

if [ $launchd_mode -eq 1 ]; then
  user=$(osascript -e 'Tell application "System Events" to display dialog "Would you like to initialize your SSH and GitHub settings?

This prompt will continue to appear at login until completed." ' 2>/dev/null)
  if (( $? )); then exit 1; fi  # Abort, if user pressed Cancel.
fi


# get user's name from git, set if not already present
existing_user_name=$(git config user.name)
sample="John Doe"
if [[ -z "$existing_user_name" ]] || [ "$existing_user_name" = "$sample" ]; then
    echo "Updating .gitconfig to include user name"

    while :; do
        print_warning "Enter your name (example: $sample): "
        read user_name && user_name=$(trim_str "$user_name")
        if [[ -z "$user_name" ]] || [ "$user_name" = "$sample" ]; then
            println_alert "You must enter a valid name; please try again."
        else
            break
        fi
    done

    # uncomment existing entry if present, otherwise the new entry is
    # applied at the bottom of the file
    sed -i ".bak" -E '/^#[[:space:]]+name[ ]*=/ s/^#//' $HOME/.gitconfig

    git config --global --replace-all user.name "$user_name"
    echo "" # newline
fi

# get email address from git, set if not already present
existing_email=$(git config user.email)
sample="john.doe@cfpb.gov"
if [[ -z "$existing_email" ]] || [ "$existing_email" = "$sample" ]; then
    echo "Updating .gitconfig to include user email"
    pattern='^[A-Za-z0-9.-]+@cfpb\.gov$'

    while :; do
        print_warning "Enter your CFPB email address (example: $sample): "
        read email && email=$(trim_str "$email")
        if [[ -z "$email" ]] || [ "$email" = "$sample" ] || [[ ! "$email" =~ $pattern ]]; then
            println_alert "You must enter your cfpb.gov email address; please try again."
        else
            break
        fi
    done

    # uncomment existing entry if present, otherwise the new entry is
    # applied at the bottom of the file
    sed -i ".bak" -E '/^#[[:space:]]+email[ ]*=/ s/^#//' $HOME/.gitconfig

    git config --global --replace-all user.email $email
    echo "" # newline
else
    email=$existing_email # need to sync for ssh key section
fi


# Create SSH key if not already present
if ! [ -f $ssh_key_file ]; then
    # Generate SSH key
    echo "No existing SSH key found... creating a new key"
    println_warning "You will be asked to create a password"
    echo "" # newline
    ssh-keygen -t rsa -C $email -f $ssh_key_file
    if [ $? != 0 ]; then
        println_alert "SSH key creation failed"
    fi
    echo "" # newline
else
    existing_ssh_key="$ssh_key_file"
fi

echo "" # newline
println_alert "######  Configuration Summary  ######"

echo  "" # newline
println_title "GitHub configuration"
if [ -n "$existing_user_name" ]; then
    echo -n " * GitHub user name already configured, left unchanged: " && println_normal "$existing_user_name"
else
    echo -n " * GitHub user name configured: " && println_normal "$user_name"
fi
if [ -n "$existing_email" ]; then
    echo -n " * GitHub email already configured, left unchanged: " && println_normal "$existing_email"
else
    echo -n " * GitHub email configured: " && println_normal "$email"
fi
echo -n " * To manually update your GitHub name and email, refer to " && println_normal "$HOME/.gitconfig"

echo "" # newline
println_title "SSH key configuration"
if [ ! -f $ssh_key_file ]; then
    println_alert "There was an error creating your new SSH key, please try again"
else
    if [ -n "$existing_ssh_key" ]; then
        echo " * Found existing SSH key, left unchanged"
    else
        echo " * Created new SSH public and private keys"
    fi
    echo " * The yellow text below is your SSH public key."
    println_warning "$(cat $ssh_key_file.pub)"

    echo "" # newline
    echo " * Log into your GitHub accounts and paste this public key your GitHub user settings."
    echo -n "   * Directions for adding keys: " && println_normal "https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account"

    echo -e  "\nThank you for completing the configuration process. To run this process again, execute the following in your terminal:"
    echo "    $script_abs_path"

    # Disable future login prompts
    if [ $launchd_mode -eq 1 ]; then
      if [ -f  $plist_file ]; then
          /usr/libexec/PlistBuddy -c "Add :Disabled bool true" $plist_file
      fi
    fi

fi
