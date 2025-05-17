# https://github.com/nvbn/thefuck

source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command thefuck; then
  eval $(thefuck --alias)
fi
