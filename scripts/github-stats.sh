#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

# ============================================================
# GitHub Profile Statistics Dashboard
# Requirements: bash (4+), curl (7.55+), jq (1.6+), xargs
#
# Usage: ./github-stats.sh [-p|--public] [username]
#   -p, --public   Skip the token prompt and run in public mode
#
# Env:   GITHUB_TOKEN (optional), JOBS (default 4), MAX_RETRIES (default 6)
#
# Modes:
#   Authenticated (token) : GraphQL stats for any user (own or a friend's),
#                           full contribution breakdown, higher rate limits.
#                           Own account also includes private/org repos.
#   Public (no token)     : REST + public profile page only. 60 API requests/hour,
#                           so large accounts may hit the limit.
# ============================================================

DEFAULT_USER="irfanshadikrishad"
API="https://api.github.com/graphql"
REST="https://api.github.com"
WEB="https://github.com"
JOBS="${JOBS:-4}"
MAX_RETRIES="${MAX_RETRIES:-6}"

# Terminal colors
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[38;5;81m'
GREEN='\033[38;5;114m'
YELLOW='\033[38;5;221m'
MAGENTA='\033[38;5;177m'
RED='\033[38;5;203m'
WHITE='\033[97m'
GRAY='\033[38;5;245m'

die() {
  printf "  ${RED}%s${RESET}\n" "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: github-stats.sh [-p|--public] [username]

  -p, --public   Skip the token prompt and use public data only
  -h, --help     Show this help

Env: GITHUB_TOKEN, JOBS (default 4), MAX_RETRIES (default 6)
EOF
  exit 0
}

# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------

FORCE_PUBLIC=0
USERNAME=""

while (($#)); do
  case "$1" in
  -p | --public) FORCE_PUBLIC=1 ;;
  -h | --help) usage ;;
  -*) die "Unknown option: $1" ;;
  *)
    [[ -z "$USERNAME" ]] || die "Only one username may be given."
    USERNAME="$1"
    ;;
  esac
  shift
done

# ------------------------------------------------------------
# Pre-flight validation
# ------------------------------------------------------------

for cmd in curl jq xargs mktemp awk grep tr; do
  command -v "$cmd" >/dev/null 2>&1 || die "Missing dependency: $cmd"
done

[[ "$JOBS" =~ ^[1-9][0-9]*$ ]] || die "JOBS must be a positive integer."
[[ "$MAX_RETRIES" =~ ^[1-9][0-9]*$ ]] || die "MAX_RETRIES must be a positive integer."

TMP="$(mktemp -d)"
STATS_DIR="$TMP/stats"
mkdir -p "$STATS_DIR"

AUTH_HDR="$TMP/auth"
GRAPHQL_BODY="$TMP/graphql.json"
YEAR_BODY="$TMP/year.json"
PROFILE_JSON="$TMP/profile.json"
HEAT_JSON="$TMP/heat.json"
HTML_BODY="$TMP/page.html"
REST_BODY="$TMP/rest.json"
REPOS="$TMP/repos.txt"
XPID=""

cleanup() {
  if [[ -n "$XPID" ]] && kill -0 "$XPID" 2>/dev/null; then
    pkill -P "$XPID" 2>/dev/null || true
    kill "$XPID" 2>/dev/null || true
  fi
  rm -rf "$TMP"
  unset TOKEN GITHUB_TOKEN
}
trap cleanup EXIT
trap 'exit 130' INT TERM

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

# Thousands separator, locale-independent. Non-numeric values pass through.
format_number() {
  local n="$1" out="" sign=""
  [[ "$n" =~ ^-?[0-9]+$ ]] || {
    printf '%s' "$n"
    return
  }
  [[ "$n" == -* ]] && {
    sign="-"
    n="${n#-}"
  }
  while ((${#n} > 3)); do
    out=",${n: -3}$out"
    n="${n:0:${#n}-3}"
  done
  printf '%s%s%s' "$sign" "$n" "$out"
}

rule() {
  local n="$1" i
  for ((i = 0; i < n; i++)); do printf '─'; done
}

# graphql <query> [variables-json] [output-file]   (token mode only)
graphql() {
  local query="$1" vars="${2:-}" out="${3:-$GRAPHQL_BODY}"
  [[ -n "$vars" ]] || vars='{}'

  jq -n --arg q "$query" --argjson v "$vars" '{query: $q, variables: $v}' |
    curl -fsS --max-time 60 --retry 3 --retry-delay 2 \
      -H @"$AUTH_HDR" \
      -H "Content-Type: application/json" \
      -H "Accept: application/vnd.github+json" \
      -X POST "$API" \
      --data-binary @- \
      -o "$out" || return 1

  if jq -e '.errors' "$out" >/dev/null 2>&1; then
    jq -r '.errors[].message' "$out" >&2
    return 1
  fi
}

# Public github.com page fetch. Never sends the token.
fetch_web() {
  curl -fsS --max-time 30 --retry 2 --retry-delay 2 \
    -H "Accept-Language: en-US,en;q=0.9" \
    -H "X-Requested-With: XMLHttpRequest" \
    "$1" -o "$2"
}

# Sanitized single-value reader for the cached profile response.
jget() {
  jq -r "$1" "$PROFILE_JSON" | tr -d '[:cntrl:]'
}

banner() {
  printf "${MAGENTA}${BOLD}"
  cat <<'EOF'
   _____ _ _   _           _
  / ____(_) | | |         | |
 | |  __ _| |_| |__  _   _| |__
 | | |_ | | __| '_ \| | | | '_ \
 | |__| | | |_| | | | |_| | |_) |
  \_____|_|\__|_| |_|\__,_|_.__/

EOF
  printf "${RESET}"
}

section() {
  echo
  printf "${CYAN}${BOLD}  %s${RESET}\n" "$1"
  printf "${GRAY}  "
  rule 45
  printf "${RESET}\n"
}

kv() {
  printf "  ${GRAY}%-30s${RESET} ${WHITE}${BOLD}%s${RESET}\n" "$1" "$2"
}

# enum_rest <url-with-query> : appends full_name of every repo to $REPOS.
enum_rest() {
  local base="$1" page=1 code count
  while true; do
    code="$(curl -sS -o "$REST_BODY" -w '%{http_code}' --max-time 30 \
      -H @"$AUTH_HDR" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "${base}&per_page=100&page=${page}" 2>/dev/null)" || code="000"

    if [[ "$code" != "200" ]]; then
      if ((page == 1)); then
        [[ "$code" == "403" || "$code" == "429" ]] &&
          die "Repository enumeration failed: API rate limit reached. Retry later or use a token."
        die "Repository enumeration failed: HTTP $code"
      fi
      printf "  ${RED}Warning: page %d failed (HTTP %s); list may be partial.${RESET}\n" "$page" "$code"
      return 0
    fi

    count="$(jq 'length' "$REST_BODY")"
    ((count > 0)) || return 0

    jq -r '.[].full_name' "$REST_BODY" >>"$REPOS"
    ((count == 100)) || return 0
    page=$((page + 1))
  done
}

# ------------------------------------------------------------
# Per-repository worker (runs in parallel via xargs)
# Writes "<status> <a> <d>" to $STATS_DIR/<repo>.res atomically.
#   ok   <added> <deleted>
#   skip <reason> 0
# ------------------------------------------------------------

fetch_repo_stats() {
  local repo="$1"
  local out="$STATS_DIR/${repo//\//__}.res"
  local body hdr attempt=1 delay=2 code="000" result
  local remaining reset retry wait_s

  body="$(mktemp "$TMP/body.XXXXXX")"
  hdr="$(mktemp "$TMP/hdr.XXXXXX")"

  emit() {
    printf '%s\n' "$1" >"$out.tmp" && mv "$out.tmp" "$out"
    rm -f "$body" "$hdr"
  }

  hval() {
    awk -F': *' -v k="$1" 'tolower($1) == k { gsub(/\r/, "", $2); print $2; exit }' "$hdr"
  }

  while ((attempt <= MAX_RETRIES)); do
    code="$(curl -sS --max-time 30 -D "$hdr" -o "$body" -w '%{http_code}' \
      -H @"$AUTH_HDR" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "$REST/repos/$repo/stats/contributors" 2>/dev/null)" || code="000"

    case "$code" in
    200)
      result="$(jq -r --arg login "$LOGIN" '
        [ (arrays // [])[]
          | select((.author.login // "") | ascii_downcase == ($login | ascii_downcase))
          | .weeks[] ]
        | "\(map(.a) | add // 0) \(map(.d) | add // 0)"
      ' "$body" 2>/dev/null)" || result=""

      if [[ "$result" =~ ^[0-9]+\ [0-9]+$ ]]; then
        emit "ok $result"
      else
        emit "skip badjson 0"
      fi
      return 0
      ;;
    204)
      emit "ok 0 0"
      return 0
      ;;
    202 | 000 | 5??)
      # 202: stats are being generated; 000/5xx: transient failure.
      sleep "$delay"
      delay=$((delay < 16 ? delay * 2 : 16))
      ;;
    403 | 429)
      remaining="$(hval x-ratelimit-remaining)"
      reset="$(hval x-ratelimit-reset)"
      retry="$(hval retry-after)"

      if [[ "$remaining" == "0" ]]; then
        # Primary quota exhausted: wait only if the reset is near.
        if [[ "$reset" =~ ^[0-9]+$ ]]; then
          wait_s=$((reset - $(date +%s)))
          if ((wait_s > 0 && wait_s <= 120)); then
            sleep $((wait_s + 1))
          else
            emit "skip ratelimit 0"
            return 0
          fi
        else
          emit "skip ratelimit 0"
          return 0
        fi
      elif [[ "$retry" =~ ^[0-9]+$ ]]; then
        sleep $((retry > 120 ? 120 : retry))
      elif grep -qi 'rate limit' "$body" 2>/dev/null; then
        sleep $((30 * attempt))
      else
        emit "skip $code 0" # SSO not authorized / no access
        return 0
      fi
      ;;
    *)
      emit "skip $code 0"
      return 0
      ;;
    esac

    attempt=$((attempt + 1))
  done

  emit "skip $code 0"
}

export -f fetch_repo_stats
export TMP STATS_DIR AUTH_HDR REST MAX_RETRIES

# ------------------------------------------------------------
# Username + authentication (token is optional)
# ------------------------------------------------------------

banner
printf "${DIM}  GitHub Profile Statistics Dashboard${RESET}\n\n"

if [[ -z "$USERNAME" ]]; then
  if [[ -t 0 ]]; then
    read -rp "  GitHub username [${DEFAULT_USER}]: " USERNAME
    USERNAME="${USERNAME:-$DEFAULT_USER}"
  else
    USERNAME="$DEFAULT_USER"
  fi
fi

[[ "$USERNAME" =~ ^[A-Za-z0-9]([A-Za-z0-9-]{0,38})$ ]] || die "Invalid GitHub username."

TOKEN=""
if ((FORCE_PUBLIC == 0)); then
  TOKEN="${GITHUB_TOKEN:-}"
  if [[ -z "$TOKEN" && -t 0 ]]; then
    read -rsp "  GitHub token (press Enter to skip → public mode): " TOKEN
    echo
  fi
fi

if [[ -n "$TOKEN" ]]; then
  [[ "$TOKEN" =~ ^[[:graph:]]+$ ]] || die "Malformed token."
  HAS_TOKEN=1
  # Token lives only in a 0600 file inside a 0700 temp dir (never in argv).
  printf 'Authorization: Bearer %s\n' "$TOKEN" >"$AUTH_HDR"
else
  HAS_TOKEN=0
  printf 'X-GitHub-Stats-Client: dashboard\n' >"$AUTH_HDR"
fi
unset TOKEN GITHUB_TOKEN
export HAS_TOKEN

if ((HAS_TOKEN)); then
  printf "\n  ${GREEN}Mode: authenticated${RESET}\n"
else
  printf "\n  ${YELLOW}Mode: public (no token; 60 API requests/hour, limited breakdown)${RESET}\n"
fi

# ------------------------------------------------------------
# Profile
# ------------------------------------------------------------

printf "  ${CYAN}Fetching profile for @%s...${RESET}\n" "$USERNAME"

IS_SELF=0

if ((HAS_TOKEN)); then
  PROFILE_QUERY='
query($login: String!) {
  viewer { login }
  user(login: $login) {
    name
    login
    bio
    createdAt
    url
    followers { totalCount }
    following { totalCount }
    repositories(privacy: PUBLIC) { totalCount }
    contributionsCollection {
      totalRepositoriesWithContributedCommits
      contributionYears
      contributionCalendar {
        weeks { contributionDays { date contributionCount } }
      }
    }
  }
}'
  PROFILE_VARS="$(jq -n --arg l "$USERNAME" '{login: $l}')"

  graphql "$PROFILE_QUERY" "$PROFILE_VARS" "$PROFILE_JSON" ||
    die "GitHub GraphQL request failed (check token validity, or run with --public)."

  jq -e '.data.user' "$PROFILE_JSON" >/dev/null 2>&1 ||
    die "User not found or token lacks access."

  NAME="$(jget '.data.user.name // .data.user.login')"
  LOGIN="$(jget '.data.user.login')"
  BIO="$(jget '.data.user.bio // "No bio"')"
  CREATED="$(jget '.data.user.createdAt[:10]')"
  PROFILE_URL="$(jget '.data.user.url')"
  FOLLOWERS="$(jget '.data.user.followers.totalCount // 0')"
  FOLLOWING="$(jget '.data.user.following.totalCount // 0')"
  PUBLIC_REPOS="$(jget '.data.user.repositories.totalCount // 0')"
  CONTRIBUTED_REPOS="$(jget '.data.user.contributionsCollection.totalRepositoriesWithContributedCommits // 0')"
  VIEWER="$(jget '.data.viewer.login // ""')"

  [[ "${LOGIN,,}" == "${VIEWER,,}" ]] && IS_SELF=1

  # Normalized heatmap data: [{date, level 0..4}]
  jq '
    [ .data.user.contributionsCollection.contributionCalendar.weeks[].contributionDays[] ] as $d
    | ([ $d[].contributionCount ] | max // 0) as $m
    | [ $d[] | {
        date: .date,
        level: (if .contributionCount == 0 then 0
                else ([ ((.contributionCount * 4 / $m) | ceil), 1 ] | max) end)
      } ]
  ' "$PROFILE_JSON" >"$HEAT_JSON" 2>/dev/null || echo '[]' >"$HEAT_JSON"

  mapfile -t YEARS < <(jq -r '.data.user.contributionsCollection.contributionYears[]' "$PROFILE_JSON")
else
  CODE="$(curl -sS -o "$PROFILE_JSON" -w '%{http_code}' --max-time 30 \
    -H @"$AUTH_HDR" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$REST/users/$USERNAME" 2>/dev/null)" || CODE="000"

  case "$CODE" in
  200) ;;
  404) die "User not found." ;;
  403 | 429) die "GitHub API rate limit reached (60/hour without a token). Retry later or use a token." ;;
  *) die "Profile request failed: HTTP $CODE" ;;
  esac

  NAME="$(jget '.name // .login')"
  LOGIN="$(jget '.login')"
  BIO="$(jget '.bio // "No bio"')"
  CREATED="$(jget '.created_at[:10]')"
  PROFILE_URL="$(jget '.html_url')"
  FOLLOWERS="$(jget '.followers // 0')"
  FOLLOWING="$(jget '.following // 0')"
  PUBLIC_REPOS="$(jget '.public_repos // 0')"
  CONTRIBUTED_REPOS="n/a (needs token)"

  CREATED_YEAR="${CREATED:0:4}"
  CURRENT_YEAR="$(date +%Y)"
  [[ "$CREATED_YEAR" =~ ^[0-9]{4}$ ]] || die "Could not determine account creation year."

  YEARS=()
  for ((y = CURRENT_YEAR; y >= CREATED_YEAR; y--)); do YEARS+=("$y"); done

  # Heatmap from the public contribution calendar (last 52 weeks).
  echo '[]' >"$HEAT_JSON"
  if fetch_web "$WEB/users/$LOGIN/contributions" "$HTML_BODY"; then
    {
      tr '\n' ' ' <"$HTML_BODY" |
        grep -oE '<td[^>]*data-date="[0-9]{4}-[0-9]{2}-[0-9]{2}"[^>]*>' |
        awk '{
          d = ""; l = ""
          if (match($0, /data-date="[0-9-]+"/))  d = substr($0, RSTART + 11, 10)
          if (match($0, /data-level="[0-9]"/))   l = substr($0, RSTART + 12, 1)
          if (d != "" && l != "") print d "\t" l
        }' |
        jq -R -s 'split("\n")
                  | map(select(length > 0) | split("\t")
                        | {date: .[0], level: (.[1] | tonumber)})' \
          >"$HEAT_JSON.tmp"
    } 2>/dev/null || true
    [[ -s "$HEAT_JSON.tmp" ]] && mv "$HEAT_JSON.tmp" "$HEAT_JSON"
  fi
fi

export LOGIN

# ------------------------------------------------------------
# Lifetime contributions (sum over every contribution year)
# ------------------------------------------------------------

YEAR_QUERY='
query($login: String!, $from: DateTime!, $to: DateTime!) {
  user(login: $login) {
    contributionsCollection(from: $from, to: $to) {
      totalCommitContributions
      totalIssueContributions
      totalPullRequestContributions
      totalPullRequestReviewContributions
      contributionCalendar { totalContributions }
    }
  }
}'

CONTRIBUTIONS=0
COMMITS=0
PRS=0
ISSUES=0
REVIEWS=0
YEAR_FAILURES=0
YEAR_ROWS=() # "year|total|commits|prs|issues|reviews" or "year|FAILED"

for YEAR in "${YEARS[@]}"; do
  printf "\r\033[K  ${CYAN}Fetching contributions for %s...${RESET}" "$YEAR"

  if ((HAS_TOKEN)); then
    VARS="$(jq -n --arg l "$USERNAME" \
      --arg f "${YEAR}-01-01T00:00:00Z" \
      --arg t "${YEAR}-12-31T23:59:59Z" \
      '{login: $l, from: $f, to: $t}')"

    if graphql "$YEAR_QUERY" "$VARS" "$YEAR_BODY"; then
      read -r Y_TOTAL Y_COMMITS Y_PRS Y_ISSUES Y_REVIEWS < <(
        jq -r '.data.user.contributionsCollection
          | [ (.contributionCalendar.totalContributions // 0),
              (.totalCommitContributions // 0),
              (.totalPullRequestContributions // 0),
              (.totalIssueContributions // 0),
              (.totalPullRequestReviewContributions // 0) ] | @tsv' "$YEAR_BODY"
      )

      CONTRIBUTIONS=$((CONTRIBUTIONS + Y_TOTAL))
      COMMITS=$((COMMITS + Y_COMMITS))
      PRS=$((PRS + Y_PRS))
      ISSUES=$((ISSUES + Y_ISSUES))
      REVIEWS=$((REVIEWS + Y_REVIEWS))

      YEAR_ROWS+=("${YEAR}|${Y_TOTAL}|${Y_COMMITS}|${Y_PRS}|${Y_ISSUES}|${Y_REVIEWS}")
    else
      YEAR_FAILURES=$((YEAR_FAILURES + 1))
      YEAR_ROWS+=("${YEAR}|FAILED")
    fi
  else
    Y_TOTAL=""
    if fetch_web "$WEB/users/$LOGIN/contributions?from=${YEAR}-01-01&to=${YEAR}-12-31" "$HTML_BODY"; then
      Y_TOTAL="$(tr '\n' ' ' <"$HTML_BODY" 2>/dev/null |
        grep -oE '[0-9][0-9,]* contributions? in (the last year|[0-9]{4})' 2>/dev/null |
        head -n1 | grep -oE '^[0-9,]+' | tr -d ',' || true)"
    fi

    if [[ "$Y_TOTAL" =~ ^[0-9]+$ ]]; then
      CONTRIBUTIONS=$((CONTRIBUTIONS + Y_TOTAL))
      YEAR_ROWS+=("${YEAR}|${Y_TOTAL}|-|-|-|-")
    else
      YEAR_FAILURES=$((YEAR_FAILURES + 1))
      YEAR_ROWS+=("${YEAR}|FAILED")
    fi
  fi
done
printf "\r\033[K"

# ------------------------------------------------------------
# Repository line statistics (parallel, with retries)
# ------------------------------------------------------------

printf "  ${CYAN}Enumerating repositories...${RESET}\n"

: >"$REPOS"

if ((IS_SELF)); then
  REPO_SCOPE="all accessible (owned, collaborator, org)"
  enum_rest "$REST/user/repos?visibility=all&affiliation=owner,collaborator,organization_member"
else
  enum_rest "$REST/users/$LOGIN/repos?type=owner"
  REPO_SCOPE="public owned repositories"

  if ((HAS_TOKEN)); then
    REPO_SCOPE="public owned + public contributed"
    CONTRIB_QUERY='
query($login: String!, $after: String) {
  user(login: $login) {
    repositoriesContributedTo(
      first: 100, after: $after, includeUserRepositories: false,
      contributionTypes: [COMMIT], privacy: PUBLIC
    ) {
      nodes { nameWithOwner }
      pageInfo { hasNextPage endCursor }
    }
  }
}'
    AFTER=""
    for ((p = 0; p < 10; p++)); do
      CVARS="$(jq -n --arg l "$LOGIN" --arg a "$AFTER" \
        'if $a == "" then {login: $l} else {login: $l, after: $a} end')"
      graphql "$CONTRIB_QUERY" "$CVARS" "$GRAPHQL_BODY" || {
        printf "  ${RED}Warning: could not list contributed repositories.${RESET}\n"
        break
      }
      jq -r '.data.user.repositoriesContributedTo.nodes[].nameWithOwner' "$GRAPHQL_BODY" >>"$REPOS"
      [[ "$(jq -r '.data.user.repositoriesContributedTo.pageInfo.hasNextPage' "$GRAPHQL_BODY")" == "true" ]] || break
      AFTER="$(jq -r '.data.user.repositoriesContributedTo.pageInfo.endCursor' "$GRAPHQL_BODY")"
    done
  fi
fi

sort -u "$REPOS" -o "$REPOS"
REPO_COUNT="$(wc -l <"$REPOS" | tr -d ' ')"

# Warn early if the anonymous quota cannot cover every repository.
if ((HAS_TOKEN == 0 && REPO_COUNT > 0)); then
  RL_REMAINING="$(curl -fsS --max-time 15 "$REST/rate_limit" 2>/dev/null |
    jq -r '.resources.core.remaining // empty' 2>/dev/null || true)"
  if [[ "$RL_REMAINING" =~ ^[0-9]+$ ]] && ((RL_REMAINING < REPO_COUNT)); then
    printf "  ${YELLOW}Warning: %s API requests left but %d repositories to scan; some will be skipped.${RESET}\n" \
      "$RL_REMAINING" "$REPO_COUNT"
  fi
fi

if ((REPO_COUNT > 0)); then
  tr '\n' '\0' <"$REPOS" |
    xargs -0 -n1 -P "$JOBS" bash -c 'fetch_repo_stats "$0"' 2>/dev/null &
  XPID=$!

  while kill -0 "$XPID" 2>/dev/null; do
    DONE="$(find "$STATS_DIR" -name '*.res' -type f | wc -l | tr -d ' ')"
    printf "\r  ${CYAN}[%3d%%]${RESET} %d/%d repositories" \
      $((DONE * 100 / REPO_COUNT)) "$DONE" "$REPO_COUNT"
    sleep 0.5
  done
  wait "$XPID" || true
  XPID=""
  printf "\r\033[K"
fi

PROCESSED=0
SKIPPED=0
TOTAL_ADDED=0
TOTAL_DELETED=0
SKIP_REASONS=""

if compgen -G "$STATS_DIR/*.res" >/dev/null; then
  read -r PROCESSED SKIPPED TOTAL_ADDED TOTAL_DELETED < <(
    cat "$STATS_DIR"/*.res | awk '
      $1 == "ok"   { p++; a += $2; d += $3; next }
      $1 == "skip" { s++ }
      END { printf "%d %d %.0f %.0f\n", p, s, a, d }'
  )
  SKIP_REASONS="$(cat "$STATS_DIR"/*.res |
    awk '$1 == "skip" { c[$2]++ }
         END { for (k in c) {
                 if (k ~ /^[0-9]+$/) printf "HTTP %s: %d\n", k, c[k]
                 else                printf "%s: %d\n", k, c[k]
               } }' | sort)"
fi

# ------------------------------------------------------------
# Dashboard
# ------------------------------------------------------------

[[ -t 1 ]] && clear
banner

printf "  ${WHITE}${BOLD}%s${RESET} (@%s)\n" "$NAME" "$LOGIN"
printf "  ${GRAY}%s${RESET}\n" "$BIO"
printf "  ${GRAY}%s · Joined %s${RESET}\n" "$PROFILE_URL" "$CREATED"
if ((HAS_TOKEN)); then
  printf "  ${DIM}Mode: authenticated${RESET}\n"
else
  printf "  ${DIM}Mode: public${RESET}\n"
fi

section "PROFILE OVERVIEW"
kv "Followers" "$(format_number "$FOLLOWERS")"
kv "Following" "$(format_number "$FOLLOWING")"
kv "Public repositories" "$(format_number "$PUBLIC_REPOS")"
kv "Contributed repos (last year)" "$(format_number "$CONTRIBUTED_REPOS")"

section "ALL-TIME CONTRIBUTIONS"
kv "Total contributions" "$(format_number "$CONTRIBUTIONS")"
if ((HAS_TOKEN)); then
  kv "Commits" "$(format_number "$COMMITS")"
  kv "Pull requests" "$(format_number "$PRS")"
  kv "Issues opened" "$(format_number "$ISSUES")"
  kv "Reviews submitted" "$(format_number "$REVIEWS")"
else
  printf "  ${DIM}Commit/PR/issue/review breakdown requires a token.${RESET}\n"
fi
((YEAR_FAILURES == 0)) ||
  printf "  ${RED}Warning: %d year(s) failed; totals are incomplete.${RESET}\n" "$YEAR_FAILURES"

# ---- Contribution history table --------------------------------------------
TABLE_FMT="  %-5s %13s %8s %6s %7s %8s"
TABLE_WIDTH=52

section "CONTRIBUTION HISTORY"
printf "${GRAY}${BOLD}${TABLE_FMT}${RESET}\n" "Year" "Contributions" "Commits" "PRs" "Issues" "Reviews"
printf "${GRAY}  "
rule "$((TABLE_WIDTH - 2))"
printf "${RESET}\n"

for ROW in "${YEAR_ROWS[@]}"; do
  IFS='|' read -r R_YEAR R_TOTAL R_COMMITS R_PRS R_ISSUES R_REVIEWS <<<"$ROW"
  if [[ "$R_TOTAL" == "FAILED" ]]; then
    printf "  ${YELLOW}%-5s${RESET} ${RED}failed to fetch${RESET}\n" "$R_YEAR"
  else
    printf "  ${YELLOW}%-5s${RESET} %13s %8s %6s %7s %8s\n" "$R_YEAR" \
      "$(format_number "$R_TOTAL")" "$(format_number "$R_COMMITS")" \
      "$(format_number "$R_PRS")" "$(format_number "$R_ISSUES")" \
      "$(format_number "$R_REVIEWS")"
  fi
done

printf "${GRAY}  "
rule "$((TABLE_WIDTH - 2))"
printf "${RESET}\n"
if ((HAS_TOKEN)); then
  printf "${WHITE}${BOLD}${TABLE_FMT}${RESET}\n" "Total" \
    "$(format_number "$CONTRIBUTIONS")" "$(format_number "$COMMITS")" \
    "$(format_number "$PRS")" "$(format_number "$ISSUES")" \
    "$(format_number "$REVIEWS")"
else
  printf "${WHITE}${BOLD}${TABLE_FMT}${RESET}\n" "Total" \
    "$(format_number "$CONTRIBUTIONS")" "-" "-" "-" "-"
fi

# ---- Contribution heatmap ---------------------------------------------------
section "CONTRIBUTION HEATMAP (LAST 52 WEEKS)"

TERM_COLS="$(tput cols 2>/dev/null || echo 80)"
[[ "$TERM_COLS" =~ ^[0-9]+$ ]] || TERM_COLS=80
CELL_W=1
((TERM_COLS >= 116)) && CELL_W=2

if jq -e 'type == "array" and length > 0' "$HEAT_JSON" >/dev/null 2>&1; then

  jq -r --argjson cw "$CELL_W" '
    def pad($n): if $n <= 0 then "" else ([range(0; $n) | " "] | join("")) end;
    def mon: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    def colors: ["\u001b[38;5;238m","\u001b[38;5;22m","\u001b[38;5;28m","\u001b[38;5;34m","\u001b[38;5;82m"];

    (sort_by(.date) | map(. + {e: ((.date + "T00:00:00Z") | fromdate)})) as $days
    | ($days[0].e) as $first
    | (($first | strftime("%w")) | tonumber) as $w0
    | ($first - ($w0 * 86400)) as $start
    | ($days | map({
        col:   (((.e - $start) / 604800) | floor),
        row:   ((.e | strftime("%w")) | tonumber),
        level: ([ (.level // 0), 4 ] | min)
      })) as $cells
    | (($cells | map(.col) | max) + 1) as $n
    | (reduce $cells[] as $c
        ([range(0; $n) | [range(0; 7) | null]]; .[$c.col][$c.row] = $c.level)) as $cols
    | ([ range(0; $n) as $i
         | ((($start + ($i * 604800)) | strftime("%m")) | tonumber) - 1 ]) as $months

    | (reduce range(0; $n) as $i ({out: "", prev: -1};
        $months[$i] as $m
        | if $m != .prev then
            (if (.out | length) <= ($i * $cw)
             then .out += pad(($i * $cw) - (.out | length)) + mon[$m]
             else . end)
            | .prev = $m
          else . end
      ) | .out) as $header

    | "    " + $header,
      ( range(0; 7) as $r
        | (["   ","Mon","   ","Wed","   ","Fri","   "][$r]) + " "
          + ( [ $cols[] | .[$r]
                | if . == null then pad($cw)
                  else colors[.] + "■" + pad($cw - 1)
                  end
              ] | join("") )
          + "\u001b[0m" )
  ' "$HEAT_JSON" | sed 's/^/  /'

  printf "\n  ${GRAY}     Less ${RESET}"
  for C in 238 22 28 34 82; do
    printf "\033[38;5;%sm■ " "$C"
  done
  printf "${RESET}${GRAY}More${RESET}\n"
else
  printf "  ${RED}Unable to retrieve contribution calendar.${RESET}\n"
fi

# ---- Code statistics --------------------------------------------------------
section "CODE STATISTICS (LIFETIME)"
kv "Repository scope" "$REPO_SCOPE"
kv "Repositories processed" "$(format_number "$PROCESSED")"
kv "Repositories skipped" "$(format_number "$SKIPPED")"
kv "Total lines added" "$(format_number "$TOTAL_ADDED")"
kv "Total lines deleted" "$(format_number "$TOTAL_DELETED")"
kv "Net line changes" "$(format_number "$((TOTAL_ADDED - TOTAL_DELETED))")"

if [[ -n "$SKIP_REASONS" ]]; then
  printf "\n  ${DIM}Skipped breakdown:${RESET}\n"
  while IFS= read -r R; do
    printf "  ${DIM}  %s${RESET}\n" "$R"
  done <<<"$SKIP_REASONS"
  printf "  ${DIM}  (202 = still computing, 403 = no access / SSO, ratelimit = API quota exhausted)${RESET}\n"
fi

echo
printf "${GRAY}  "
rule 45
printf "${RESET}\n"
printf "  ${GREEN}${BOLD}Dashboard generated successfully.${RESET}\n"
if ((HAS_TOKEN)); then
  printf "  ${DIM}Data source: GitHub GraphQL + REST API${RESET}\n"
else
  printf "  ${DIM}Data source: GitHub REST API + public profile page${RESET}\n"
fi
printf "  ${DIM}Profile: %s${RESET}\n" "$PROFILE_URL"
echo
