# https://github.com/junegunn/fzf

# Set Homebrew prefix if not already set
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

# Add fzf binary to PATH if missing
if [[ ":$PATH:" != *":$HOMEBREW_PREFIX/opt/fzf/bin:"* ]]; then
  export PATH="${PATH:+${PATH}:}$HOMEBREW_PREFIX/opt/fzf/bin"
fi

# Enable fzf completion and key bindings
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
