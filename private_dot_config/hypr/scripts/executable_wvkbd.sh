#!/usr/bin/env bash
set -euo pipefail

action=${1:-toggle}
case "$action" in
    start|toggle|show|hide) ;;
    *) printf 'Usage: %s [start|toggle|show|hide]\n' "$0" >&2; exit 2 ;;
esac

runtime_dir=${XDG_RUNTIME_DIR:?A Wayland session is required}
exec 9>"$runtime_dir/wvkbd-deskintl.lock"
flock 9

if pgrep -u "$UID" -x wvkbd-deskintl >/dev/null; then
    case "$action" in
        toggle) pkill -RTMIN -u "$UID" -x wvkbd-deskintl ;;
        show) pkill -USR2 -u "$UID" -x wvkbd-deskintl ;;
        hide) pkill -USR1 -u "$UID" -x wvkbd-deskintl ;;
    esac
elif [[ "$action" != hide ]]; then
    options=(-H 360 -L 300 --fn 'Sans 16')
    # Reserve space below applications so the keyboard doesn't cover text fields.
    if [[ "$action" == start ]]; then
        options+=(--hidden)
    fi
    nohup /usr/bin/wvkbd-deskintl "${options[@]}" \
        </dev/null >"$runtime_dir/wvkbd-deskintl.log" 2>&1 9>&- &
fi
