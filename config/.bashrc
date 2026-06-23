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
export EDITOR='nix shell nixpkgs#neovim --command nvim'
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# F12 for clipboard selection
bind '"\e[24~":"clip-select\r"'
# F8 for clipboard pruning
bind '"\e[19~":"clip-prune\r"'

# -------------------- Configure paths ----------------------------------------
# My personal scripts come first in search order
export PATH="$HOME/bin:$PATH"

# Various local tools come after personal scripts
export PATH="$HOME/.local/bin:$PATH"

# uv (and possibly other binaries)
export PATH="$PATH:$HOME/.local/bin/env"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Configure cargo and Rust binaries
# . "$HOME/.cargo/env"

# Golang
export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Configure NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# For now, most work is SEIU, and putting uv cache on external drive will 
# allow for more efficient access (same physical drive is needed), use
# `--cache-dir=blah` to override
export UV_CACHE_DIR="/media/dmertz/DQM-Backup/uv-cache"

# PYTHONPATH includes Ada development
export PYTHONPATH="$PYTHONPATH:$HOME/SEIU/ada-unified/server"
export BITDROP_NO_EMAIL=1

# -------------------- Aliases ------------------------------------------------
# Use isolated and auto-updated nix packages
alias bat='nix shell nixpkgs#bat --command bat'
alias chafa='nix shell nixpkgs#chafa --command chafa'
alias cloc='nix shell nixpkgs#cloc --command cloc'
alias dust='nix shell nixpkgs#dust --command dust'
alias fetch='nix shell nixpkgs#fastfetch --command fastfetch'
alias gum='nix shell nixpkgs#gum --command gum'
alias java='nix shell nixpkgs#jre --command java'
alias links='nix shell nixpkgs#links2 --command links'
alias ls='nix shell nixpkgs#eza --command eza'
alias lh='nix shell nixpkgs#eza --command eza -laGh --time-style=long-iso --no-user'
alias ll='nix shell nixpkgs#eza --command eza -laB'
alias lynx='nix shell nixpkgs#lynx --command lynx'
alias nv='nix shell nixpkgs#neovim --command nvim'
alias nvim=nv
alias nvs='nv -S'
alias pandoc='nix shell nixpkgs#pandoc --command pandoc'
alias ruby='nix shell nixpkgs#ruby --command ruby'
alias stylua='nix shell nixpkgs#stylua --command stylua'
alias tldr='nix shell nixpkgs#tealdeer --command tldr'
alias tree='nix shell nixpkgs#eza --command eza -T -L2'

# Add switches or use substitute executables
alias cd='z'
alias clear-scrollback="printf '\033[3J'"
alias bfg='java -jar /usr/share/bfg-1.15.0.jar'
alias chbash="nvim $HOME/.bashrc"
alias cloc='cloc --exclude-list-file=.clocignore'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias g='grep -P --color=always'
alias grep='grep --color=auto'
alias load='source ~/.bashrc'
alias mc='mc --nosubshell'
alias public-ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias py='ipython --classic'
alias pytest='uv run pytest -W ignore'
alias shinfo='echo "$SHELL, level $SHLVL, name: $name"'
alias speedtest='speedtest --secure'
alias tree-bin='/usr/bin/tree'
alias v='xdg-open'
alias view='$HOME/bin/view'
alias venv='. .venv/bin/activate; export PYTHONPATH=$(pwd)'
alias vim='NO_AI=Y nvim'
alias weather='clear && curl -s wttr.in/Portland,ME?3nQ'
alias y=yazi

# Interactive DB connections
alias adacat='catalist-rds-ada'
alias postcat='catalist-rds-postgres'
alias redshift='ssh ubuntu@52.39.136.106'

# SSH shortcuts
BOT_LOCAL="192.168.0.105"
alias ada-prod='ssh ubuntu@instance.ada.seiu.org'
alias ada-test='ssh ubuntu@instance.test.ada.dsa.seiu.org'
alias ada-staging='ssh ubuntu@instance.staging.ada.dsa.seiu.org'
alias dsa-runner='ssh ubuntu@ec2-52-26-78-240.us-west-2.compute.amazonaws.com'
alias dsa-wiki='ssh ubuntu@35.85.102.203'
alias bitdrop='ssh ubuntu@44.228.185.80'
alias bot-ui='ssh ec2-user@44.239.233.71'
alias bot-infer="ssh bossbot@$BOT_LOCAL"
alias bot-dmertz="ssh dmertz@$BOT_LOCAL"

# -------------------- General functions/commands -----------------------------
exit() {
    # Often we wish to exit nix shell or other nested shell. 
    # Avoid exiting entire terminal if we are at top level
    if [[ $SHLVL != 1 ]]; then
        echo "Exiting shell (level $SHLVL; name: $name)"
        builtin exit 2> /dev/null
    else
        read -p "Exit the terminal? (yes/no) " yn
        case $yn in 
            y | Y | yes | Yes | YES) builtin exit 2> /dev/null;;
            *) echo "Remaining in shell (level $SHLVL)";;
        esac
    fi
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
    local psql
    _USER=${ADACAT_USER:-ada}
    _PORT=${ADACAT_PORT:-5432}
    _HOST=${ADA_HOST:-app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com}
    _DB=${ADACAT_DATABASE:-ada}
    _PW=${ADACAT_PASSWORD:-$(pass ada:app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com)}
    _OPT='--search_path=catalist_periodic_install'
    pgcli='uvx --with pgcli pgcli'
    PGOPTIONS=$_OPT PGPASSWORD=$_PW ${pgcli} -h $_HOST -p $_PORT -d $_DB -U $_USER $@
}
catalist-rds-postgres() {
    local psql
    _USER=${ADACAT_USER:-postgres}
    _PORT=${ADACAT_PORT:-5432}
    _HOST=${ADACAT_HOST:-app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com}
    _DB=${ADACAT_DATABASE:-ada}
    _PW=${ADACAT_PASSWORD:-$(pass postgres:app-ada-db-test.c7efsggzq3du.us-west-2.rds.amazonaws.com)}
    _OPT='--search_path=catalist_periodic_install'
    pgcli='uvxi --with pgcli pgcli'
    PGOPTIONS=$_OPT PGPASSWORD=$_PW ${pgcli} -h $_HOST -p $_PORT -d $_DB -U $_USER $@
}
ada-env() {
    source $HOME/.bashrc
    cd $HOME/SEIU/ada-unified
    uv sync
    source .venv/bin/activate
    set -a; source .env; set +a
    export PYTHONPATH="$PYTHONPATH:$PWD/server"
    export PYTHONPATH=$(ruby -e "print ARGV[0].split(':').uniq.join(':')" $PYTHONPATH)
    mkdir -p /tmp/ada
    mkdir -p /tmp/ada-events
    mkdir -p /tmp/local
    export ADA_PSEUDO_S3="/tmp/ada"
    export ADA_EVENTS_PSEUDO_S3="/tmp/ada-events"
    export ADA_PERSISTENT="/tmp/local"
    export ADA_HOME="$HOME/SEIU/ada-unified/server"
}

# git stuff
export GIT_PAGER='nix shell nixpkgs#bat --command bat -p'

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
fzf_batstyle="--preview 'bat --style numbers,changes --color=always {} | head -500'"
fzf_prevwin='--preview-window=down,40%,wrap,border-rounded'
export FZF_DEFAULT_OPTS="${fzv_batstyle} ${fzf_prevwin}"
export FZF_DEFAULT_COMMAND='ag -l --hidden -g ""'

# Glow for markdown preview
[ -s "$HOME/.config/glow.sh" ] && source "$HOME/.config/glow.sh"

# Initialize zoxide
eval "$(zoxide init bash)"

# Miscellaneous shell enhancements
# Make ctrl-R work

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
color_prompt=yes

# -------------------------- Final tooling for shell --------------------------
# FZF (especially ctrl-R being usable)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# ------------ Enable `nix` commands for environment isolation ----------------
. /home/dmertz/.nix-profile/etc/profile.d/nix.sh

# -------------------- Remove duplicate path entries --------------------------
# The Ruby version is much more concise, but leave the longer awk as comment
# in case someone wants to use this on a system without Ruby installed.
export PATH=$(ruby -e "print ARGV[0].split(':').uniq.join(':')" $PATH)
export PYTHONPATH=$(ruby -e "print ARGV[0].split(':').uniq.join(':')" $PYTHONPATH)
# export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
# export PYTHONPATH=$(echo -n $PYTHONPATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')

