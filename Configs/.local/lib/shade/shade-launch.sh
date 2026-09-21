#!/usr/bin/env bash
[[ $SHADE_SHELL_INIT -ne 1 ]] && eval "$(shade-shell init)"

notify-send -a "Deprecation Notice" "shade-launch.sh is deprecated. Please use shade-shell open instead." -i dialog-information

shade-shell open "$@"
