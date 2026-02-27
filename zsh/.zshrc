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

# Make Homebrew tools (including Python) take precedence
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"

############################################
#            Prompt (Starship)              #
############################################

eval "$(starship init zsh)"


############################################
#          Navigation Enhancements          #
############################################

# zoxide: initialized at end of file (must be last to avoid hook conflicts)


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
# (Add your personal aliases here or in ~/.oh-my-zsh/custom/aliases.zsh)

# Example: open zshrc quickly
alias zshconfig="vim ~/.zshrc"
alias reload="source ~/.zshrc"


############################################
#               NVM Settings                #
############################################
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# .NET Core SDK
export PATH="$HOME/.dotnet:$PATH"
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$HOME/.local/bin:$PATH"

############################################
#     zoxide (MUST be last in .zshrc)      #
############################################

# --cmd cd replaces the built-in cd with zoxide
eval "$(zoxide init zsh)"
