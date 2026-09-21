#!/usr/bin/env bash
[[ $SHADE_SHELL_INIT -ne 1 ]] && eval "$(shade-shell init)"
lockscreen="${HYPRLAND_LOCKSCREEN:-hyprlock}"
lockscreen="${LOCKSCREEN:-$lockscreen}"
lockscreen="${SHADE_LOCKSCREEN:-$lockscreen}"
source "${LIB_DIR}/shade/shutils/argparse.sh"
argparse_init "$@"
argparse_program "shade-shell lockscreen"
argparse_header "shade Lockscreen Launcher"
argparse "--get" "" "Get the current lockscreen command"
argparse_finalize

case $ARGPARSE_ACTION in
    get) echo "$lockscreen" && exit 0 ;;
esac

unit_name="shade-lockscreen.service"
args=(-u "$unit_name" -t service)
if which "$lockscreen.sh" 2> /dev/null 1>&2; then
    printf "Executing $lockscreen wrapper script : %s\n" "$lockscreen.sh"
    app.sh "${args[@]}" -- "$lockscreen.sh" "$@"
else
    printf "Executing raw command: %s\n" "$lockscreen"
    app.sh "${args[@]}" -- "$lockscreen" "$@"
fi
