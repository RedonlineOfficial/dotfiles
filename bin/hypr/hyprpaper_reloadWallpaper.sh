#!/usr/bin/env bash

# ---------------------------------------- #
# Hyprpaper Script - Load/Reload Wallpaper #
# ---------------------------------------- #

WALLPAPER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/wallpapers"
DEFAULT_WALLPAPER="archLinuxDark_darkLogo.jpg"

# Debug control:
# - Env var: HYPRPAPER_DEBUG=1
# - Flag:    -d / --debug
DEBUG="${HYPRPAPER_DEBUG:-0}"

debug() {
    [ "$DEBUG" != "0" ] && printf '[hyprpaper-reload][DEBUG] %s\n' "$*" >&2
}

CURRENT_WALLPAPERS=$(hyprctl hyprpaper listloaded | xargs -n1 basename 2>/dev/null || true)
USER_WALLPAPER=""

debug "Starting hyprpaper_reloadWallpaper.sh"
debug "WALLPAPER_DIR=$WALLPAPER_DIR"
debug "DEFAULT_WALLPAPER=$DEFAULT_WALLPAPER"
debug "CURRENT_WALLPAPERS=$(printf '%s\n' "$CURRENT_WALLPAPERS")"

while [ $# -gt 0 ]; do
    case "$1" in
        -d|--debug)
            DEBUG=1
            debug "Debug flag enabled via CLI"
            shift
            ;;
        -f|--file)
            if [ $# -lt 2 ]; then
                echo "Error: $1 requires an argument" >&2
                exit 2
            fi
            USER_WALLPAPER="$2"
            debug "USER_WALLPAPER set via -f/--file: $USER_WALLPAPER"
            shift 2
            ;;
        -l|--list)
            debug "Listing wallpapers in $WALLPAPER_DIR"
            for filepath in "$WALLPAPER_DIR"/*; do
                filename=$(basename "$filepath")
                if echo "$CURRENT_WALLPAPERS" | grep -qx "$filename"; then
                    echo -e "⭐ $filename (\e[0;32mCurrent Wallpaper\e[0m)"
                else
                    echo -e "   $filename"
                fi
            done
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            debug "Unknown argument encountered: $1"
            exit 1
            ;;
    esac
done

if [ -n "$USER_WALLPAPER" ]; then
    case "$USER_WALLPAPER" in
        /*)
            WALLPAPER="$USER_WALLPAPER"
            ;;
        *)
            WALLPAPER="$WALLPAPER_DIR/$USER_WALLPAPER"
            ;;
    esac
    debug "Using user-specified wallpaper: $WALLPAPER"
else
    WALLPAPER="$WALLPAPER_DIR/$DEFAULT_WALLPAPER"
    debug "Using default wallpaper: $WALLPAPER"
fi

if [ ! -f "$WALLPAPER" ]; then
    echo "ERROR: wallpaper not found: $WALLPAPER" >&2
    debug "Wallpaper file missing: $WALLPAPER"
    exit 3
fi

debug "Running: hyprctl hyprpaper reload \",$WALLPAPER\""

# If debug is on, enable shell tracing so the Hyprland log shows the call
if [ "$DEBUG" != "0" ]; then
    set -x
fi

hyprctl hyprpaper reload ",$WALLPAPER"

if [ "$DEBUG" != "0" ]; then
    set +x
    debug "Reload command completed"
fi
