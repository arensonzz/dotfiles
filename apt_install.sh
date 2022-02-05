#!/usr/bin/env bash

####################################
# You should run this file as SUDO #
####################################

DISTRO=${1^^} # turn to all uppercase
EMAIL=${2}
USER_HOME="$(getent passwd $SUDO_USER | cut -d: -f6)"

if [ "$#" -ne 2 ]; then
    echo "E: Illegal number of parameters"
    echo "usage: sudo bash apt_install.sh distro_name email_addr"
    exit 1
fi

case $DISTRO in
UBUNTU)
	echo '### INSTALLING FOR UBUNTU ###'
	;;
*)
	echo E: not supported distro
    echo 'usage: sudo bash apt_install.sh distro_name email_addr'
	exit 1
	;;
esac

TEMP_DIR=$HOME/setup-temp
LOG_DIR=/tmp/system_install

mkdir -p $LOG_DIR
mkdir -p $TEMP_DIR
# push user's directory onto stack
pushd $(pwd)
cd $TEMP_DIR

# Empty log files
echo "" >$LOG_DIR/apt_install.log

# print output to both log file and console
# https://stackoverflow.com/a/55968253/13175265
test x$1 = x$'\x00' && shift || { set -o pipefail ; ( exec 2>&1 ; $0 $'\x00' "$@" ) | tee $LOG_DIR/apt_install.log ; exit $? ; }

echo '# RUNNING APT-GET UPDATE #'
apt-get -qq --yes update
echo '> APT-GET UPDATE FINISHED <'

### Global software installation using apt-get
echo '### GLOBAL SOFTWARE ###'
echo '# INSTALLING APT APPS #'

apt-get -qq --yes install bat
apt-get -qq --yes install apt-file
apt-get -qq --yes install clangd
apt-get -qq --yes install curl
apt-get -qq --yes install fd-find
if ! [ -x "$(command -v git)" ]; then
    # Configure git for the first install
    apt-get -qq --yes install git
    git config --global user.name "$(whoami)"
    git config --global user.email "$EMAIL"
    git config --global color.ui true
    git config --global core.editor vim
else
    apt-get -qq --yes install git
fi

apt-get -qq --yes install grep
apt-get -qq --yes install ripgrep
apt-get -qq --yes install tidy
apt-get -qq --yes install translate-shell
apt-get -qq --yes install trash-cli
apt-get -qq --yes install unzip
apt-get -qq --yes install valgrind
apt-get -qq --yes install wget
apt-get -qq --yes install xclip
apt-get -qq --yes install xdg-utils
apt-get -qq --yes install subversion
apt-get -qq --yes install libgtk-3-dev
apt-get -qq --yes install neofetch
if ! [ -x "$(command -v zsh)" ]; then
    # Configure zsh for the first install
    apt-get -qq --yes install zsh
    echo "Changing default shell to ZSH."
    chsh -s $(which zsh) $USER_HOME
    echo "W: Please logout after for default shell change to take effect."
else
    apt-get -qq --yes install zsh
fi

apt-get -qq --yes install tmux
apt-get -qq --yes install ffmpeg
apt-get -qq --yes install python3-pip

echo '> APT APPS INSTALL FINISHED <'
echo '# INSTALLING PYENV DEPENDENCIES #'
apt-get -qq --yes install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
echo '> PYENV DEPENDENCY INSTALL FINISHED <'
