source "/opt/homebrew/opt/spaceship/spaceship.zsh"

# Define a custom order to exclude all runtime environments (Node, Python, etc.)
# This boosts performance and keeps the UI clean.
SPACESHIP_PROMPT_ORDER=(
  user          # Current username
  dir           # Current working directory
  host          # Hostname
  git           # Git status (branch, dirty, etc.)
  time
  line_sep      # New line before the prompt character
  jobs          # Background jobs indicator
  exit_code     # Exit code of the last command
  char          # The prompt character (e.g., ➜)
)

# Show time section
SPACESHIP_TIME_SHOW=true
# Customize format (e.g., 14:30:01)
SPACESHIP_TIME_FORMAT='%D{%H:%M:%S}'
# Disable execution time (took X seconds)
SPACESHIP_EXEC_TIME_SHOW=false

# Optional: Ensure async rendering is on for better performance
SPACESHIP_PROMPT_ASYNC=true
