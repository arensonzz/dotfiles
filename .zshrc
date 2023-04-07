# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

################
# TERMINAL START
################

### WSL2 CONFIG
# Change WSL2 directory colors for readability
#   Change ls colours
# export CLICOLOR=1
# export LS_COLORS='rs=0:no=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32:'
#   Make cd use the ls colours
# zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Aliases
# alias explorer='/mnt/c/Windows/explorer.exe .'

# Set browser
# alias firefox="/mnt/c/Firefox/firefox.exe"

alias usage='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'

### PROGRAM ALIASES
# translate-shell
alias td='trans :tr'

# fzf
alias fzfp="fzf --preview 'batcat --style=numbers --color=always {} | head -500'"

# Make history command show all history
alias history='fc -l 1'

# config --bare git repository
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Git aliases
alias gs='git status'
alias gsh='git stash'
alias gc='git commit'
alias gm='git merge'
alias gd='git diff'
alias gco='git checkout'
alias gl='git log --oneline'
alias glg='git log --oneline --all --decorate --graph'
alias ga='git add'
alias gb='git branch'
alias gpl='git pull'
alias gph='git push'

# neovim
alias vim="stty stop '' -ixoff; nvim" # disable Ctrl + S mapping of the terminal before running nvim
alias nvim="stty stop '' -ixoff; nvim" # disable Ctrl + S mapping of the terminal before running nvim

# fd-find (fd)
alias fd='fdfind'

# batcat (bat)
alias bat='batcat --theme=TwoDark'

# pip3
alias pip='pip3'

# NPM
#   add fixer/linter dependencies
alias devtools_web_vanilla='pnpm add -D eslint prettier eslint-plugin-prettier eslint-config-prettier stylelint stylelint-config-standard'
alias devtools_web_svelte_eslint='pnpm add -D eslint eslint-plugin-svelte3 eslint-plugin-import typescript @typescript-eslint/parser @typescript-eslint/eslint-plugin @rollup/plugin-typescript @tsconfig/svelte stylelint stylelint-config-recommended-scss stylelint-config-html postcss postcss-html sass prettier prettier-plugin-svelte'
alias devtools_web_svelteserver='pnpm add -D eslint eslint-plugin-prettier eslint-config-prettier typescript @rollup/plugin-typescript @tsconfig/svelte stylelint stylelint-config-recommended-scss stylelint-config-html postcss postcss-html sass prettier prettier-plugin-svelte'

# Docker
alias sd='sudo -E docker'

# feh
alias fehzoom='feh --auto-zoom --force-aliasing --geometry 1280x720'

# ip
alias ip='ip --color=auto'

# BindToInterface
alias wlo1_bind="BIND_INTERFACE=wlo1 DNS_OVERRIDE_IP=1.1.1.1 DNS_EXCLUDE=127.0.0.1 LD_PRELOAD=$HOME/programs/BindToInterface/bindToInterface.so"
alias usb0_bind="BIND_INTERFACE=usb0 DNS_OVERRIDE_IP=1.1.1.1 DNS_EXCLUDE=127.0.0.1 LD_PRELOAD=$HOME/programs/BindToInterface/bindToInterface.so"


# Rsync
#   sync home
alias sync_home="rsync -gloptruch --stats --delete --exclude={'/subfolders/','/Music/','/Downloads/','/Pictures/','/Videos/','/VirtualBox\ VMs/','/.local/','/.cache/','/.cargo/','/.npm/','/.nvm/','/projects/languages/rust/**/target','/projects/languages/latex/**/build','/projects/**/node_modules','/projects/languages/c/**/Debug'} /home/arensonz/ '/media/arensonz/Linux Files/Backups/aren-zenbook'"

#   sync shared files
alias sync_subfolders="rsync -gloptruch --stats --delete /home/arensonz/subfolders '/media/arensonz/Shared Files/'"

alias sync_music="rsync -gloptruch --stats --delete /home/arensonz/Music '/media/arensonz/Shared Files/'"
alias rsync_restore="rsync -gloptrch --stats"


### SCRIPT ALIASES
alias fwhite='format_whitespace.py'

### REMINDER/CORRECTOR ALIASES
# alias rm='echo "Use trash instead of rm (use \\\\rm -i if you want to skip this warning.)"'

### CONFIGS
# Activate tab completion
autoload -Uz compinit
compinit
autoload -U bashcompinit
bashcompinit

# Disable autocorrect in zsh  (nyae prompt)
unsetopt correct
unsetopt correctall
DISABLE_CORRECTION="true"

# Overwrite existing files with > and >>.
setopt CLOBBER

### FUNCTIONS
# mkdir and cd to that directory
function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

### MODULE INITIALIZATION
# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# p10k
#   To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#   bash completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PyEnv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# initialize pipx
#   Set pipx default python interpreter
export PIPX_DEFAULT_PYTHON="$HOME/.pyenv/versions/$(pyenv version-name)/bin/python"
#   Load pipx completions
eval "$(register-python-argcomplete pipx)"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

export PNPM_HOME="/home/arensonz/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# dotnet
export PATH="$HOME/.dotnet/tools:$PATH"
