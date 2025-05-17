# https://github.com/gsamokovarov/jump#integration

source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command jump; then
  eval "$(jump shell)"
fi
