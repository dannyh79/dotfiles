# Returns 0 (true) if the command exists and is executable
has_command() {
  command -v "$1" >/dev/null 2>&1 && [ -x "$(command -v "$1")" ]
}
