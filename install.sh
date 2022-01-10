#!/bin/bash
#
#

# set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

echo " "
echo '                     |\__/,|   (`\   ';
echo '                   _.|o o  |_   ) )  ';
echo '                 -(((---(((--------  ';
echo "##################################################### "
echo "######                                         ###### "
echo "######           install dependencies          ###### " 
echo "######        brew, wget, pyenv, python        ###### " 
echo "######          wwww.jonahlmadeya.com          ###### " 
echo "######                                         ###### "
echo "##################################################### " 

sudo -v

username=$(id -un)
fullName=$(id -F)
userDir=$(eval echo ~$USER)
scriptsDir="$userDir/Scripts"

echo " "
echo "Hello $fullName"
echo " "
echo "This script will install the minimum development tools and dependencies for my scripts then disappear!"
echo " "

echo "####### START INSTALL ##################################################### "
echo " "

echo "Installing xcode CLI..."
# install xcode CLI
xcode-select —-install

echo "Check if Homebrew is installed, if not install it..."
# Check for Homebrew to be present, install if it's missing
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

exec $SHELL

echo "Updating Homebrew..."
# Update homebrew recipes
brew update

# list packages to install
PACKAGES=(
    pyenv
    wget
)

# install them 
echo "Installing packages..."
brew install ${PACKAGES[@]}

exec $SHELL


echo "Configuring Pyenv..."
# set up PYENV
pyenv init


if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
   # assume Zsh
   echo '
        if command -v pyenv 1>/dev/null 2>&1; then
            eval "$(pyenv init -)"
        fi' >> /Users/$username/.zshrc
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
   # assume Bash

    if [ -f "/Users/$username/.bash_profile" ]; then
        echo '
            if command -v pyenv 1>/dev/null 2>&1; then
                eval "$(pyenv init -)"
            fi' >> /Users/$username/.bash_profile
    elif [ -f "/Users/$username/.profile" ]; then
        echo '
            if command -v pyenv 1>/dev/null 2>&1; then
                eval "$(pyenv init -)"
            fi' >> /Users/$username/.profile
    elif [ -f "/Users/$username/.bashrc" ]; then
        echo '
            if command -v pyenv 1>/dev/null 2>&1; then
                eval "$(pyenv init -)"
            fi' >> /Users/$username/.bashrc
    else 
        echo "cannot find configuration file"
    fi

else
   echo "cannot find shell details"
fi

exec $SHELL

echo "Installing Python..."
pyenv install 3.10.0

pyenv global 3.10.0

# install python packages
echo "Installing Python packages (Instaloader)..."

PYTHON_PACKAGES=(
    instaloader
)
sudo pip3 install ${PYTHON_PACKAGES[@]}

echo " "
echo "####### END INSTALL DEP ##################################################### "

echo " "
echo "Congrats! Your environement is ready for jonah's scripts!";
