export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# For Midnight Commander specifically
export VIEWER='bat --paging=always'
export EDITOR='nvim'

export PATH="$HOME/bin:/opt/homebrew/opt/ruby/bin:$PATH"
export PATH=$(ruby -e "print ARGV[0].split(':').uniq.join(':')" $PATH)

. "$HOME/.local/bin/env"
