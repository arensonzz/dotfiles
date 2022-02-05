#!/usr/bin/env bash

########################################
# You should NOT run this file as SUDO #
########################################

DISTRO=${1^^} # turn to all uppercase
EMAIL=${2}

if [ "$#" -ne 2 ]; then
    echo "E: Illegal number of parameters"
    echo "usage: sudo bash install.sh distro_name email_addr"
    exit 1
fi

case $DISTRO in
UBUNTU)
	echo '### INSTALLING FOR UBUNTU ###'
	;;
*)
	echo E: not supported distro
    echo 'usage: sudo bash install.sh distro_name email_addr'
	exit 1
	;;
esac

TEMP_DIR=$HOME/setup-temp
LOG_DIR=/tmp/system_install

# print output to both log file and console
# https://stackoverflow.com/a/55968253/13175265
test x$1 = x$'\x00' && shift || { set -o pipefail ; ( exec 2>&1 ; $0 $'\x00' "$@" ) | tee $LOG_DIR/install.log ; exit $? ; }

mkdir -p $LOG_DIR
mkdir -p $TEMP_DIR
# push user's directory onto stack
pushd $(pwd)
cd $TEMP_DIR

### Prezto installation using git
echo '### PREZTO ###'

if ! [ -d "$HOME/.zprezto" ]; then
    echo '# INSTALLING PREZTO FOR ZSH #'
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    echo '> PREZTO INSTALL FINISHED <'
else
    echo '# W: .ZPREZTO FOLDER ALREADY EXISTS, UPDATING #'
    zprezto-update
fi

echo '>>> PREZTO FINISHED <<<'

### Downloading applications from their repos
echo '### REPOSITORIES FROM WEB ###'

# install neovim
if ! [ -x "$(command -v nvim)" ]; then
    echo '# INSTALLING NEOVIM #'
    curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o "nvim"
    chmod u+x nvim
    sudo mv nvim /usr/local/bin
else
    echo '# W: NEOVIM ALREADY INSTALLED (CHECK LATEST VERSION FROM NEOVIM/NEOVIM GITHUB PAGE!) #'
fi

# install nvm
if ! [ -x "$(command -v nvm)" ]; then
    echo '# INSTALLING NVM (V0.39.1) #'
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
else
    echo '# W: NVM ALREADY INSTALLED (CHECK LATEST VERSION FROM NVM-SH/NVM GITHUB PAGE!) #'
fi

# install nodejs
if ! [ -x "$(command -v node)" ]; then
    echo '# INSTALLING LATEST LTS NODEJS #'

    # reload terminal to obtain nvm
    sudo -i -u "$(whoami)" zsh <<EOF
        nvm install --lts
        nvm alias default node
        nvm use --lts
EOF

else
    echo '# W: NODEJS ALREADY INSTALLED (CHECK LATEST VERSION FROM "NVM LIST" COMMAND!) #'
fi

# install pyenv
if ! [ -x "$(command -v pyenv)" ]; then
    echo '# INSTALLING LATEST PYENV #'
    # install pyenv using automatic installer
    curl -L https://github.com/psyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    # reload terminal to obtain pyenv
    sudo -i -u "$(whoami)" zsh <<EOF
        # install pyenv plugins
        git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update

        git clone git://github.com/pyenv/pyenv-doctor.git $(pyenv root)/plugins/pyenv-doctor
        git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
        git clone https://github.com/momo-lab/xxenv-latest.git "$(**env root)"/plugins/xxenv-latest
        pyenv update

        # install latest python version inside pyenv
        pyenv latest install
        pyenv latest global
EOF
else
    echo '# W: PYENV ALREADY INSTALLED, UPDATING #'
    pyenv update
fi

# install pipx
if ! [ -x "$(command -v pipx)" ]; then
    echo '# INSTALLING LATEST PIPX #'
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
else
    echo '# W: PIPX ALREADY INSTALLED, UPDATING #'
    python3 -m pip install --user -U pipx
fi

# install fzf
if ! [ -x "$(command -v fzf)" ]; then
    echo '# INSTALLING LATEST FZF #'
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install
else
    echo '# W: FZF ALREADY INSTALLED, UPDATING #'
    pushd $(pwd)
    cd $HOME/.fzf && git pull
    ./install
    popd
fi

echo '>>> REPOSITORIES FROM WEB FINISHED <<<'

### Installing applications using npm
echo '### NPM APPS ###'

if [ -x "$(command -v npm)" ]; then
    echo '# INSTALLING NPM APPS #'
    # reload terminal to obtain npm
    sudo -i -u "$(whoami)" zsh <<EOF
        npm i -g --quiet livedown
        npm i -g --quiet live-server
        npm i -g --quiet http-server
        npm i -g --quiet neovim
        npm i -g --quiet tldr
        npm i -g --quiet sql-lint
        npm i -g --quiet wsl-open
        echo '> NPM APPS INSTALL FINISHED <'
        echo '# UPDATING NPM APPS #'
        npm i -g --quiet npm-check-updates
EOF
else
    echo '# E: NPM NOT INSTALLED, COULD NOT INSTALL THE APPS #'
fi

echo '>>> NPM APPS FINISHED <<<'

### Installing applications using pipx
echo '### PIPX APPS ###'

if [ -x "$(command -v pipx)" ]; then
    echo '# INSTALLING PIPX APPS #'
    # reload terminal to obtain npm
    sudo -i -u "$(whoami)" zsh <<EOF
        pipx install yt-dlp
        pipx install flake8
        pipx install autopep8
        pipx install youtube-dl
        pipx install jedi-language-server
        pipx install pycodestyle
        echo '> PIPX APPS INSTALL FINISHED <'

        echo '# UPDATING PIPX APPS #'
        pipx upgrade-all
EOF
else
    echo '# E: PIPX NOT INSTALLED, COULD NOT INSTALL THE APPS #'
fi

echo '>>> PIPX APPS FINISHED <<<'

### Configurations
echo '### CONFIGURATIONS ###'

if [ ! -f $HOME/.ssh/id_rsa.pub ]; then
    echo '# CONFIGURING SSH #'
	ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -C $EMAIL
	eval "$(ssh-agent -s)"
	ssh-add $HOME/.ssh/id_rsa
else
    echo '# W: SSH ALREADY CONFIGURED #'
fi

echo '>>> CONFIGURATIONS FINISHED <<<'


rm -rf $TEMP_DIR

echo Purged temp folder

### Checking if apps are installed correctly
echo '### CHECKING INSTALLATIONS ###'

echo '- nvim version:'
nvim --version
echo '- nvm version:'
nvm --version
echo '- node version:'
nvm list
echo '- pyenv check'
pyenv doctor
echo '- pipx version:'
pipx --version
echo '- default python version:'
python --version
echo '>>> CHECKING INSTALLATIONS FINISHED <<<'

### Reminder
echo '### REMEMBER TO ###:'
echo - update all packages and the system
echo - register ssh public key to github
echo " -check $TMP_DIR for error logs"
echo '- download recommended font for powerlevel10k (MesloLGS NF)'
echo - reboot

# go back to user's directory
popd
