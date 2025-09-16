# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# -------------------- Configure prompt ---------------------------------------
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export CLICOLOR=1
export PS1="\[\e]2; \w (\u)\a\]\!-\[\e[1;38m\]\W\[\e[0m\e[1;37m\] %\[\e[0m\] "

# A bit of sanity in tool preferences
export EDITOR=nvim
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# F12 for Rofi menu
bind '"\e[24~":"rofi -show\r"'

# -------------------- Configure paths ----------------------------------------
# My personal scripts come first in search order
export PATH="$HOME/bin:$PATH"

# Various local tools come after personal scripts
export PATH="$HOME/.local/bin:$PATH"

# uv (and possibly other binaries)
export PATH="$PATH:$HOME/.local/bin/env"

# Neovim
export PATH="$PATH:/opt/nvim"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Configure cargo and Rust binaries
. "$HOME/.cargo/env"

# Golang
export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin"

# Configure NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYTHONPATH="$PYTHONPATH:$HOME/SEIU/ada-unified/server"

# For now, most work is SEIU, and putting uv cache on external drive will 
# allow for more efficient access (same physical drive is needed), use
# `--cache-dir=blah` to override
export UV_CACHE_DIR="/media/dmertz/DQM-Backup/uv-cache"

# -------------------- Aliases ------------------------------------------------
# Some aliases to functions defined herein below
alias cd='z'
alias clear-scrollback="printf '\033[3J'"
alias clip='copyq add -'
alias cloc='cloc --exclude-list-file=.clocignore'
alias egrep='egrep --color=auto'
alias fd='fdfind'
alias fgrep='fgrep --color=auto'
alias g='grep -P --color=always'
alias grep='grep --color=auto'
alias load='source ~/.bashrc'
alias ls='exa'
alias lh='exa -laGh --time-style=long-iso --no-user'
alias ll='exa -laB'
alias nv='nvim'
alias nvs='nv -S'
alias public-ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias py='ipython --classic'
alias pytest='uv run pytest -W ignore'
alias speedtest='speedtest --secure'
alias tree-bin='/usr/bin/tree'
alias tree='exa -T -L2'
alias v='xdg-open'
alias view='$HOME/bin/view'
alias venv='. .venv/bin/activate; export PYTHONPATH=$(pwd)'
alias vim='NO_AI=Y nvim'
alias y=yazi

# Interactive DB connections
alias adacat='catalist-rds-ada'
alias postcat='catalist-rds-postgres'
alias redshift='ssh ubuntu@52.39.136.106'

# SSH shortcuts
alias ada-prod='ssh ubuntu@instance.ada.seiu.org'
alias ada-grav-prod='ssh ubuntu@34.212.87.14'
alias ada-test='ssh ubuntu@instance.test.ada.dsa.seiu.org'
alias ada-staging='ssh ubuntu@instance.staging.ada.dsa.seiu.org'
alias ada-grav-stag='ssh ubuntu@35.80.161.215'
alias ada-runner='ssh ubuntu@ec2-35-166-221-187.us-west-2.compute.amazonaws.com'
alias dsa-runner='ssh ubuntu@ec2-52-26-78-240.us-west-2.compute.amazonaws.com'
alias bot-ui='ssh ec2-user@44.239.233.71'
alias bot-infer='ssh -p443 bossbot@70.105.237.83'
export ContractBot="70.105.237.83"

# -------------------- General functions/commands -----------------------------
gd() {
    git diff "$@" | diff-so-fancy | less -r
}
header() { 
  clear; toilet -f future --filter border " $1 "; echo; sleep 3; 
}
jwtp() {
    jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[1] | @base64d | fromjson' $1
}
jwth() {
    jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[0] | @base64d | fromjson' $1
}

# -------------------- SEIU functions/commands --------------------------------
catalist-rds-ada() {
    _USER=${ADACAT_USER:-ada}
    _PORT=${ADACAT_PORT:-5432}
    _HOST=${ADA_HOST:-app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com}
    _DB=${ADACAT_DATABASE:-ada}
    _PW=${ADACAT_PASSWORD:-$(pass ada:app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com)}
    _OPT='--search_path=catalist_periodic_install'
    PGOPTIONS=$_OPT PGPASSWORD=$_PW psql -h $_HOST -p $_PORT -d $_DB -U $_USER $@
}
catalist-rds-postgres() {
    _USER=${ADACAT_USER:-postgres}
    _PORT=${ADACAT_PORT:-5432}
    _HOST=${ADACAT_HOST:-app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com}
    _DB=${ADACAT_DATABASE:-ada}
    _PW=${ADACAT_PASSWORD:-$(pass postgres:app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com)}
    _OPT='--search_path=catalist_periodic_install'
    PGOPTIONS=$_OPT PGPASSWORD=$_PW psql -h $_HOST -p $_PORT -d $_DB -U $_USER $@
}
ada-env() {
    source $HOME/.bashrc
    cd $HOME/SEIU/ada-unified
    mkdir -p /tmp/ada
    uv sync
    source .venv/bin/activate
    set -a; source .env; set +a
    export PYTHONPATH="$PYTHONPATH:$PWD/server"
    export PYTHONPATH=$(ruby -e "print ARGV[0].split(':').uniq.join(':')" $PYTHONPATH)
    export ADA_PSEUDO_S3=/tmp/ada
    export ADA_HOME=$HOME/SEIU/ada-unified/server
}

# -------------------- Shell usability aids -----------------------------------
# Install thefuck
eval $(thefuck --alias fuck)
alias fix=fuck

# git stuff
export GIT_PAGER='batcat -p'

# Bash-git-prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_END="\[\e[0m\e[1;37m\]\n%\[\e[0m\] "
    GIT_PROMPT_START="\[\e]2; \w (\u)\a\]\!-\[\e[2;38m\]\W\[\e[0m\]"
    source $HOME/.bash-git-prompt/gitprompt.sh
fi

# Bash-git-completion
source ~/bin/git-completion.bash

# Some tool looks for SSL certs
export SSL_CERT_DIR=/etc/ssl/certs

# FZF, and indirectly vim that uses plugin to choose files with it
export FZF_DEFAULT_OPTS="--preview 'bat --style numbers,changes --color=always {} | head -500' --preview-window=down,40%,wrap,border-rounded"
export FZF_DEFAULT_COMMAND='ag -l --hidden -g ""'

# Glow for markdown preview
[ -s "$HOME/.config/glow.sh" ] && source "$HOME/.config/glow.sh"

# Initialize zoxide
eval "$(zoxide init bash)"

# Miscellaneous shell enhancements
# TODO: look at `source /usr/share/doc/fzf/examples/key-bindings.bash`
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Prompt always starts on new line
get_column() {
  exec < /dev/tty
  local oldstty=$(stty -g)
  stty raw -echo min 0
  echo -en "\033[6n" > /dev/tty
  local pos
  IFS=';' read -r -d R -a pos
  stty $oldstty
  echo "$((${pos[1]} - 1))"
}
__configure_prompt() { if [ "$(get_column)" != 0 ]; then echo; fi }
PROMPT_COMMAND="__configure_prompt;$PROMPT_COMMAND"
export PROMPT_COMMAND=$(ruby -e "print ARGV[0].split(';').uniq.join(';')" $PROMPT_COMMAND)

# -------------------- Remove duplicate path entries --------------------------
# The Ruby version is much more concise, but leave the longer awk as comment
# in case someone wants to use this on a system without Ruby installed.
export PATH=$(ruby -e "print ARGV[0].split(':').uniq.join(':')" $PATH)
export PYTHONPATH=$(ruby -e "print ARGV[0].split(':').uniq.join(':')" $PYTHONPATH)
# export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
# export PYTHONPATH=$(echo -n $PYTHONPATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')

# -------------------- History settings ---------------------------------------
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# -------------------- Preconfigured stuff (prune as desired) ------------------
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

