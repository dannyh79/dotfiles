# https://github.com/junegunn/fzf

# Set Homebrew prefix if not already set
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

# Enable fzf completion and key bindings
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
