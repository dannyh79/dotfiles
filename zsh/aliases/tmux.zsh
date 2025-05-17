source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command tmux; then
  alias ta="tmux a"
fi
