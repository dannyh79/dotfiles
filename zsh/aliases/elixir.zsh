source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command iex; then
  alias im="iex -S mix"
  alias imp="iex -S mix phx.server"
fi
