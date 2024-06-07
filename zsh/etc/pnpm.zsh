# https://github.com/pnpm/pnpm
export PNPM_HOME="/Users/dhan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
