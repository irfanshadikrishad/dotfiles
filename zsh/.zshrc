# ----------------------------------------
# Powerlevel10k Instant Prompt (MUST STAY TOP)
# ----------------------------------------
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load modular config
ZSH_CONFIG="$HOME/.config/zsh"

for file in $ZSH_CONFIG/*.zsh; do
  source "$file"
done
