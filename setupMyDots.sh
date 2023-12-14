git init --bare $HOME/.mydots
alias config='/usr/bin/git --git-dir=$HOME/.mydots/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
