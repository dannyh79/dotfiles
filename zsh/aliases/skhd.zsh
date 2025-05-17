# Simple hotkey daemon for macOS
# https://github.com/koekeishiya/skhd

source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command skhd; then
  alias skhdreload="skhd --restart-service"
fi
