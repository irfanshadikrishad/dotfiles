#!/usr/bin/env bash
# Check domain (.com .io .app .dev .net .co) and social username availability in parallel.
# Usage: namecheck.sh [name]

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
RESET=$'\033[0m'

AVAILABLE="${GREEN}✓ available${RESET}"
TAKEN="${RED}✗ taken${RESET}"
RATE_LIMITED="${YELLOW}⚠ rate limited${RESET}"
TIMEOUT="${YELLOW}? timeout${RESET}"
UNKNOWN="${YELLOW}? unknown${RESET}"

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

PIDS=()
LABELS=()
FILES=()
SECTIONS=()

launch() {
    local section="$1" label="$2" func="$3"
    shift 3
    local idx="${#PIDS[@]}"
    local file="$WORKDIR/$idx"
    "$func" "$@" "$file" &
    PIDS+=("$!")
    LABELS+=("$label")
    FILES+=("$file")
    SECTIONS+=("$section")
}

get_status() {
    curl -s -o /dev/null -w "%{http_code}" \
        --max-time 10 --connect-timeout 5 \
        -A "Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0" \
        "$1" 2>/dev/null || echo "000"
}

http_result() {
    case "$1" in
        200) echo "$TAKEN" ;;
        404) echo "$AVAILABLE" ;;
        429|403) echo "$RATE_LIMITED" ;;
        000) echo "$TIMEOUT" ;;
        *) echo "${YELLOW}? $1${RESET}" ;;
    esac
}

check_domain() {
    local domain="$1" out="$2"

    # Primary: RDAP — standardized registry protocol, unaffected by site uptime
    local s
    s=$(curl -s -o /dev/null -w "%{http_code}" -L \
        --max-time 10 --connect-timeout 5 \
        "https://rdap.org/domain/$domain" 2>/dev/null)
    case "$s" in
        200) echo "$TAKEN" > "$out"; return ;;
        404) echo "$AVAILABLE" > "$out"; return ;;
        429) echo "$RATE_LIMITED" > "$out"; return ;;
    esac

    # Secondary: whois text parsing
    if command -v whois &>/dev/null; then
        local w
        w=$(whois "$domain" 2>/dev/null | tr '[:upper:]' '[:lower:]')
        if echo "$w" | grep -qE \
            'no match|not found|no entries found|status: free|no data found|object does not exist|available for registration|is free|no object found|domain not found'; then
            echo "$AVAILABLE" > "$out"; return
        elif echo "$w" | grep -qE \
            'domain name:|registrant|creation date|registered|created:|expiry date|updated date'; then
            echo "$TAKEN" > "$out"; return
        fi
    fi

    # Tertiary: DNS NS record check — NS records exist for registered domains even when the site is down
    if command -v dig &>/dev/null; then
        local ns
        ns=$(dig +short NS "$domain" 2>/dev/null)
        if [[ -n "$ns" ]]; then
            echo "$TAKEN" > "$out"
        else
            local status
            status=$(dig +noall +comments "$domain" 2>/dev/null | grep -oi 'status: [A-Z]*' | head -1)
            if [[ "$status" == "status: NXDOMAIN" ]]; then
                echo "$AVAILABLE" > "$out"
            else
                echo "$UNKNOWN" > "$out"
            fi
        fi
    else
        echo "$UNKNOWN" > "$out"
    fi
}

check_github() {
    local user="$1" out="$2"
    local s
    s=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 \
        "https://api.github.com/users/$user" 2>/dev/null)
    case "$s" in
        200) echo "$TAKEN" ;;
        404) echo "$AVAILABLE" ;;
        403|429) echo "$RATE_LIMITED" ;;
        *) echo "${YELLOW}? $s${RESET}" ;;
    esac > "$out"
}

check_bluesky() {
    local user="$1" out="$2"
    local s
    s=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 \
        "https://public.api.bsky.app/xrpc/com.atproto.identity.resolveHandle?handle=${user}.bsky.social" \
        2>/dev/null)
    case "$s" in
        200) echo "$TAKEN" ;;
        400|404) echo "$AVAILABLE" ;;
        *) echo "${YELLOW}? $s${RESET}" ;;
    esac > "$out"
}

check_http() {
    local url="$1" out="$2"
    http_result "$(get_status "$url")" > "$out"
}

check_instagram() {
    local user="$1" out="$2"
    local s
    s=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 --connect-timeout 5 \
        -A "Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0" \
        -H "X-IG-App-ID: 936619743392459" \
        "https://www.instagram.com/api/v1/users/web_profile_info/?username=$user" \
        2>/dev/null)
    case "$s" in
        200) echo "$TAKEN" ;;
        404) echo "$AVAILABLE" ;;
        429|403) echo "$RATE_LIMITED" ;;
        000) echo "$TIMEOUT" ;;
        *) echo "${YELLOW}? $s${RESET}" ;;
    esac > "$out"
}

# ─── Input ────────────────────────────────────────────────────────────────────

NAME="${1:-}"
if [[ -z "$NAME" ]]; then
    printf "Enter name to check: "
    read -r NAME
fi
[[ -z "$NAME" ]] && { echo "No name provided." >&2; exit 1; }

NAME_LOWER=$(printf '%s' "$NAME" | tr '[:upper:]' '[:lower:]')
DSLUG=$(printf '%s' "$NAME_LOWER" | tr ' ' '-' | tr -cd 'a-z0-9-')
USLUG=$(printf '%s' "$NAME_LOWER" | tr -d ' ' | tr -cd 'a-z0-9_')

[[ -z "$DSLUG" ]] && { echo "Name produces an empty slug." >&2; exit 1; }

printf '\n%sChecking:%s %s%s%s\n' "$BOLD" "$RESET" "$CYAN" "$NAME" "$RESET"
printf '%sdomain slug: %s  |  username: %s%s\n\n' "$DIM" "$DSLUG" "$USLUG" "$RESET"

# ─── Launch all checks in parallel ───────────────────────────────────────────

launch domain "${DSLUG}.com"  check_domain  "${DSLUG}.com"
launch domain "${DSLUG}.io"   check_domain  "${DSLUG}.io"
launch domain "${DSLUG}.app"  check_domain  "${DSLUG}.app"
launch domain "${DSLUG}.dev"  check_domain  "${DSLUG}.dev"
launch domain "${DSLUG}.net"  check_domain  "${DSLUG}.net"
launch domain "${DSLUG}.co"   check_domain  "${DSLUG}.co"

launch social "github.com/$USLUG"         check_github  "$USLUG"
launch social "bsky.app/$USLUG"           check_bluesky "$USLUG"
launch social "x.com/$USLUG"              check_http    "https://x.com/$USLUG"
launch social "instagram.com/$USLUG"      check_instagram  "$USLUG"
launch social "linkedin.com/in/$DSLUG"    check_http    "https://www.linkedin.com/in/$DSLUG"
launch social "reddit.com/u/$USLUG"       check_http    "https://www.reddit.com/user/$USLUG/about.json"
launch social "pinterest.com/$USLUG"      check_http    "https://www.pinterest.com/$USLUG/"
launch social "tiktok.com/@$USLUG"        check_http    "https://www.tiktok.com/@$USLUG"
launch social "facebook.com/$USLUG"       check_http    "https://www.facebook.com/$USLUG"

# ─── Collect and display in order ────────────────────────────────────────────

cur_section=""
for (( i = 0; i < ${#PIDS[@]}; i++ )); do
    sec="${SECTIONS[$i]}"
    if [[ "$sec" != "$cur_section" ]]; then
        [[ "$cur_section" == "domain" ]] && printf '\n'
        if [[ "$sec" == "domain" ]]; then
            printf '%s%sDomains%s\n' "$BOLD" "$BLUE" "$RESET"
        else
            printf '%s%sSocial Profiles%s\n' "$BOLD" "$BLUE" "$RESET"
        fi
        cur_section="$sec"
    fi
    wait "${PIDS[$i]}" 2>/dev/null || true
    printf '  %-34s' "${LABELS[$i]}"
    cat "${FILES[$i]}" 2>/dev/null || echo "$UNKNOWN"
done

printf '\n'
