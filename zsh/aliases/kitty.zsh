source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command kitten; then
  alias icat="kitten icat"
fi
