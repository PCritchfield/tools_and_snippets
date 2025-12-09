############################################
#              History Settings             #
############################################

# Keep a large, shared history with good hygiene
HISTSIZE=200000
SAVEHIST=200000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_DUPS         # ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS     # delete older duplicates
setopt HIST_IGNORE_SPACE        # commands starting with space aren't saved
setopt HIST_VERIFY              # verify ! expansions
setopt APPEND_HISTORY           # append instead of overwrite
setopt SHARE_HISTORY            # share history across sessions
setopt EXTENDED_HISTORY         # timestamp each entry (helps Atuin imports)

############################################
#           Oh My Zsh Initialization        #
############################################

export ZSH="$HOME/.oh-my-zsh"

plugins=(
  git
  history-substring-search
  brew
  aws
  aliases
)

# Disable OMZ themes because Starship provides prompt
ZSH_THEME=""

source $ZSH/oh-my-zsh.sh


############################################
#                PATH Setup                 #
############################################

export PATH="$HOME/bin:$PATH"


############################################
#            Prompt (Starship)              #
############################################

eval "$(starship init zsh)"


############################################
#          Navigation Enhancements          #
############################################

# zoxide: smarter cd
eval "$(zoxide init zsh)"


############################################
#          History Searching (Atuin)        #
############################################

# Atuin replaces Ctrl-R with fuzzy, ranked history search
eval "$(atuin init zsh)"


############################################
#      Autosuggestions & Highlighting       #
############################################

# Autosuggestions must load before syntax highlighting
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting MUST be last
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


############################################
#        history-substring-search keys      #
############################################

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


############################################
#               QoL Aliases                 #
############################################
# (Your main alias file lives in ~/.oh-my-zsh/custom/aliases.zsh)

alias zshconfig="vim ~/.zshrc"
alias reload="source ~/.zshrc"


############################################
#               NVM Settings                #
############################################

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
