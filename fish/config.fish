# ALIAS
alias ls=eza
alias ll="eza -lahg"
alias cv="python -m venv .venv"
alias cva="source .venv/bin/activate.fish"
alias ads="func azure functionapp fetch-app-settings"
alias adc="func settings decrypt"

# GIT
alias g="git"
alias gs="git status"
alias gb="git branch"
alias gch="git checkout"
alias gc="git commit"
alias gd="git diff"
alias gf="git fetch --all"
alias gfr="git fetch --all; git reset --hard origin/master"
alias gpr="git pull --rebase"
alias gl="git l"

# ssl
set -gx SSL_CERT_DIR ~/.certs/
set -gx PATH /Users/CHAGRED/TokenUpdater /usr/local/libexec/ $PATH

eval (/opt/homebrew/bin/brew shellenv)
starship init fish | source
zoxide init fish | source
