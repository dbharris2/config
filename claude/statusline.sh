#  ~/.config/claude/statusline.sh

#!/bin/bash
input=$(cat)

# Extract data from JSON input
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Get VCS info: prefer jj, fall back to Sapling
VCS_INFO=""
if [ -d ".jj" ]; then
    COMMIT=$(jj log -r @ --no-graph -T 'if(immutable, concat(if(bookmarks, bookmarks.join(", "), "main")), if(description, description.first_line(), change_id.shortest(8)))' 2>/dev/null | awk '{if(length>40) print substr($0,1,37)"…"; else print}')
    [ -n "$COMMIT" ] && VCS_INFO=" | \033[33m🥷 $COMMIT\033[0m"
elif sl root > /dev/null 2>&1; then
    COMMIT=$(sl log -r . -T '{desc|firstline}' 2>/dev/null)
    [ ${#COMMIT} -gt 40 ] && COMMIT="${COMMIT:0:37}..."
    [ -n "$COMMIT" ] && VCS_INFO=" | \033[33m🌱 $COMMIT\033[0m"
fi

# Format cost to 2 decimal places
COST_FMT=$(printf "%.2f" "$COST")

# Build context bar with color thresholds
GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '█')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

# Build status line with colors
echo -e "\033[36m[$MODEL]\033[0m 📁 ${DIR##*/}$VCS_INFO | 💰 \$$COST_FMT | ${BAR_COLOR}${BAR}${RESET} ${PCT}%"
