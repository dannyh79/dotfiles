# Fixing Vim's incorrect theme coloring
export TERM="xterm-256color"

# Set default editor as nvim for Git, etc
export EDITOR=$(which nvim)

# Use "^X^E" to open multi-line editor with nvim ($EDITOR) in zsh
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
