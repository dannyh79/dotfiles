load_every_file_in_dir() {
  if [[ -d "$1" ]]; then
    for file in $1/*; do
      if [[ -f $file ]]; then
        source $file
      fi
    done
  else
    echo "Directory not found: $1"
  fi
}
