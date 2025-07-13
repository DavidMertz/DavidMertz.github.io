# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dmertz/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/dmertz/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/dmertz/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/dmertz/.fzf/shell/key-bindings.bash"
