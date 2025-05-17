# Tiling window manager for macOS
# https://github.com/koekeishiya/yabai

source "$HOME/.config/zsh/internal/has_command.zsh"

if has_command yabai; then
  alias yabaireload="yabai --restart-service"
fi
