source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command nvim; then
  alias e="nvim"
  alias zshconfig="nvim ~/.zshrc"
  alias zshreload="source ~/.zshrc"
fi
