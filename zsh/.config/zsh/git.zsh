gitc() {
  local message="$1"
  local input_date="$2"
  local final_date

  if [[ -z "$message" ]]; then
    echo "Usage: gitc \"commit message\" [YYYY-MM-DD | full date string]"
    return 1
  fi

  if [[ -z "$input_date" ]]; then
    final_date="$(date '+%Y-%m-%d %H:%M:%S')"
  elif [[ "$input_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    final_date="$input_date 00:00:00"
  else
    final_date="$input_date"
  fi

  GIT_AUTHOR_DATE="$final_date" \
  GIT_COMMITTER_DATE="$final_date" \
  git commit -m "$message" --date "$final_date"
}

GITSTATUS_LOG_LEVEL=DEBUG
