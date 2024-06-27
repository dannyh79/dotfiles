# Simple hotkey daemon for macOS
# https://github.com/koekeishiya/skhd

if [ -x "$(command -v skhd)" ]; then
  alias skhdreload="skhd --restart-service"
fi
