# Created by Homebrew 
eval "$(/opt/homebrew/bin/brew shellenv)"

# Created by `pipx` on 2025-07-22 15:17:17
export PATH="$PATH:/Users/francoaseglio/.local/bin"

# Borders
if ! pgrep -x borders >/dev/null; then
  borders \
    active_color=0xffe1e3e4 \
    inactive_color=0xff494d64 \
    width=2.0 \
    >/dev/null 2>&1 &
  disown
fi
