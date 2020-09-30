#!/usr/bin/env bash
#############################################################
#                                                             #
#   How to use this:                                          #
#     * Download this file                                    #
#     * Run `chmod 755 bootstrap.sh` within its directory     #
#     * Install everything by running `./bootstrap.sh`        #
#                                                             #
#   If you want to install a small scope of all this stuff:   #
#     * Open the file                                         #
#     * Put a `#` before every thing you do not want          #
#     * Run `./bootstrap.sh` to install everything you want   #
#                                                             #
###############################################################

# Define some URLs and stuff, because it is ugl
CURRENT_DIRECTORY=$(pwd)
BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
OH_MY_ZSH_URL="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

# here the real script starts
echo "Welcome to the install script!"
# running brew as root would be not intended - so sudo is not allowed
if [[ $(id -u) -eq 0 ]] ; then echo "Please do not run as root" ; exit 1 ; fi
if ! [ "$(uname)" = "Darwin" ]; then echo "Seems to be not MacOS..."; exit 1; fi

#TODO: Install ruby?
# install brew and update it
which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL $BREW_URL)"
else
  brew update
fi

echo "Installing git..."
brew install git

# best practice is to have a .profile file that has all handcrafted scripts
touch ~/.profile
SOURCE_PROFILE="source ~/.profile"

# provide a shell environment
echo "Do you prefer zsh or bash? Currently you use $SHELL"
read INPUT_SHELL;
case $INPUT_SHELL in
*zsh)
  echo "Installing zsh..."
  brew install zsh
  ! grep -q $(which zsh) /etc/shells && sudo sh -c "echo $(which zsh) >> /etc/shells"
  chsh -s $(which zsh)
  SHELL=$(which zsh)
  echo "Do you want to to use Oh-My-Zsh?(Y/n)"
  read OH_MY_ZSH
  case $OH_MY_ZSH in
  [nN])
    echo "Okay, no Oh-My-Zsh for you..."
    ;;
  *)
    echo "Installing Oh-My-Zsh..."
    sh -c "RUNZSH=no $(curl -fsSL $OH_MY_ZSH_URL) --unattended"
    ;;
  esac
  ! grep -q "$SOURCE_PROFILE" ~/.zshrc && echo "$SOURCE_PROFILE" >> ~/.zshrc
  ;;
*bash)
  chsh -s $(which bash)
  SHELL=$(which bash)
  ! grep -q "$SOURCE_PROFILE" ~/.bashrc && echo "$SOURCE_PROFILE" >> ~/.bashrc
  ;;
*)
  echo "I don't recognize this shell - i will do nothing for now..."
  ;;
esac

echo "Installing coreutils..."
brew install coreutils

echo "Installing font Source Code Pro..."
brew tap homebrew/cask-fonts && brew cask install font-source-code-pro

echo "Installing firefox developer edition..."
brew cask install homebrew/cask-versions/firefox-developer-edition

echo "Installing chrome..."
brew cask install google-chrome

echo "Installing emacs..."
# is the preferred way according to emacs wiki
brew cask install emacs

if [ -z "$(ls -A ~/.emacs.d)" ]; then
  echo "Installing spacemacs...";
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d;
fi

echo "Installing aspell..."
brew install aspell

echo "Installing VS Code..."
brew cask install visual-studio-code

echo "Installing Soap-UI..."
brew cask install soapui

echo "Installing Postman..."
brew cask install postman

echo "Installing Tower..."
brew cask install tower

echo "Installing Slack..."
brew cask install slack

echo "Installing Cisco Proximity..."
brew cask install cisco-proximity

echo "Installing Python3..."
brew install python

echo "Installing Python2..."
brew install python@2

echo "installing elixir..."
brew install elixir

echo "Instelling and setup for postgresql..."
brew install postgresql
brew services start postgresql
createuser -d postgres

echo "installing vmware fusion..."
brew cask install vmware-fusion

cd $CURRENT_DIRECTORY

echo "Installing awscli tools...."
# Install guide https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-macOS.html
curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-macos.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscli2.zip


echo "Installing nodenv..."
brew install nodenv
nodenv init

# install nodenv as Node.js manager
NODENV_INIT='eval "$(nodenv init -)"'
! grep -q $NODENV_INIT ~/.profile && echo $NODENV_INIT >> ~/.profile

brew install nodenv/nodenv/node-build-update-defs
nodenv update-version-defs
NODENV_BUILD_DEFS='NODE_BUILD_DEFINITIONS=$(brew --prefix node-build-update-defs)/share/node-build'
! grep -q $NODENV_BUILD_DEFS ~/.profile && echo $NODENV_BUILD_DEFS >> ~/.profile

source ~/.profile
nodenv install 12.16.1
nodenv global 12.16.1

echo "Installing rust..."
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
RUST_ENV='source $HOME/.cargo/env'
! grep -q "$RUST_ENV" ~/.profile && echo "$RUST_ENV" >> ~/.profile

echo "Deactivate the captive portal detection, because I like to trigger those by curl"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean false
sudo -k shutdown -r now

