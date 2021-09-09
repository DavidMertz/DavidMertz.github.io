export PS1="\[\e]2; \w (\u)\a\]\!-\[\e[1;38m\]\W\[\e[0m\e[1;37m\] %\[\e[0m\] " 
#export PS1="[\w]\$ "

# My personal scripts
export PATH=$HOME/bin:$PATH

# Java
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")

# Golang
export PATH=$PATH:/usr/local/go/bin

# Rust
export PATH=$PATH:"$HOME/.cargo/bin"

# Ruby
export PATH=$PATH:$HOME/.rbenv/bin
eval "$(rbenv init - bash)"

# Keep a bit more history
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignorespace

# Some colors and aliases
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export CLICOLOR=1
alias less='less --RAW-CONTROL-CHARS'
alias lc='ls -G --color=always'
alias ll='ls -laG --color=always'
alias clear-scrollback="printf '\033[3J'"
alias g='egrep --color=always'
alias sl='some-letters'
alias las='letters-and-subseq'
alias pcat="pygmentize -f terminal256 -O style=native -g"
alias deepthought='clear;ponysay -b round $(fortune)'
alias v=xdg-open
export LESS=' -R '

# Install thefuck
eval $(thefuck --alias)
alias fix=fuck

# Bash-git-prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_END="\[\e[0m\e[1;37m\]\n%\[\e[0m\] "
    GIT_PROMPT_START="\[\e]2; \w (\u)\a\]\!-\[\e[2;38m\]\W\[\e[0m\]"
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
# Bash-git-completion
source ~/bin/git-completion.bash

# Remove duplicate path entries
export PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
export PYTHONPATH=$(echo -n $PYTHONPATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')

# Some tool looks for SSL certs
export SSL_CERT_DIR=/etc/ssl/certs

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dmertz/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dmertz/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/dmertz/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/dmertz/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
