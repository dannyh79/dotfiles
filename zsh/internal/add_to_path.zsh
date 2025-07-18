# Add args to $PATH if not exist
add_to_path() {
  for dir in "$@"; do
    [[ -z "$dir" || ! -d "$dir" ]] && continue
    dir="${(e)dir%/}"
    case ":$PATH:" in
      *":$dir:"*)
        # If already in PATH, remove it and then add to the beginning
        PATH=$(echo "$PATH" | sed -e "s|:$dir:|$dir:|g" -e "s|^$dir:||g" -e "s|:$dir$||g" -e "s|::|:|g" -e "s|^:||g" -e "s|:$||g")
        export PATH="$dir:$PATH"
        ;;
      *)
        # If not in PATH, add to the beginning
        export PATH="$dir:$PATH"
        ;;
    esac
  done
}
