# Add args to $PATH if not exist
add_to_path() {
  for dir in "$@"; do
    [[ -z "$dir" || ! -d "$dir" ]] && continue
    dir="${(e)dir%/}"
    case ":$PATH:" in
      *":$dir:"*) ;;
      *) export PATH="$dir:$PATH" ;;
    esac
  done
}
