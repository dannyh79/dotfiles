# Using "zzzz-" to ensure this file is loaded last; thus the highest priority in path entries.

# asdf - Tool version manager
# https://asdf-vm.com/guide/getting-started.html

ASDF_SHIMS_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

PATH_ENTRIES+=("$ASDF_SHIMS_DIR")
