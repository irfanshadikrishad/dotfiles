# ── Basic viewing ──────────────────────────────────────────────

# View last 1000 lines as a static snapshot (fresh, no old data)
alias goaccess-now='sudo tail -n 1000 /var/log/nginx/access.log | goaccess --log-format=COMBINED -'

# Live real-time monitoring (follows new requests as they come in)
alias goaccess-live='sudo tail -F /var/log/nginx/access.log | goaccess --log-format=COMBINED -'

# Full static analysis of the entire current log file
alias goaccess-full='sudo goaccess /var/log/nginx/access.log --log-format=COMBINED'

# ── HTML dashboard output ─────────────────────────────────────

# Generate a standalone HTML report from the full log
alias goaccess-html='sudo goaccess /var/log/nginx/access.log --log-format=COMBINED -o /tmp/goaccess-report.html && echo "Report: /tmp/goaccess-report.html"'

# Generate a live-updating HTML dashboard on port 7890
alias goaccess-html-live='sudo goaccess /var/log/nginx/access.log --log-format=COMBINED --real-time-html -o /var/www/html/goaccess.html'

# ── Filtered views ────────────────────────────────────────────

# Only show 404 errors (find broken links / scanners)
alias goaccess-404='sudo goaccess /var/log/nginx/access.log --log-format=COMBINED --ignore-status=200 --ignore-status=301 --ignore-status=302 --ignore-status=304'

# Only show requests from the last hour (approximate via tail)
alias goaccess-recent='sudo tail -n 5000 /var/log/nginx/access.log | goaccess --log-format=COMBINED -'

# ── Multiple / rotated logs ───────────────────────────────────

# Analyze current log + all rotated .gz logs together
alias goaccess-all='zcat /var/log/nginx/access.log.*.gz 2>/dev/null | cat - /var/log/nginx/access.log | sudo goaccess --log-format=COMBINED -'

# ── Apache equivalents (if you use Apache) ────────────────────

alias goaccess-apache-now='sudo tail -n 1000 /var/log/apache2/access.log | goaccess --log-format=COMBINED -'
alias goaccess-apache-live='sudo tail -F /var/log/apache2/access.log | goaccess --log-format=COMBINED -'

# ── Reset persisted database ──────────────────────────────────

# Wipe GoAccess persisted DB so next run starts fresh
alias goaccess-reset='sudo rm -rf /var/lib/goaccess-db/* /tmp/goaccess* 2>/dev/null; echo "GoAccess DB cleared"'

# Correctly check if any .env file was actually served (200 on the request path)
alias goaccess-env-check='sudo awk '\''$7 ~ /\.env/ && $9 == 200 {print}'\'' /var/log/nginx/access.log || echo "✅ No .env files were served"'

alias sync-sshrc='cp ~/workshop/dotfiles/zsh/.config/zsh/goaccess.zsh ~/.sshrc && echo "~/.sshrc synced"'
