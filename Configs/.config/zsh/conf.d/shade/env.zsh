#!/usr/bin/env zsh

# shade Shell Environment Initialization

case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) PATH="$HOME/.local/bin:$PATH" ;;
esac

typeset -gx XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
typeset -gx XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
typeset -gx XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
typeset -gx XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
typeset -gx XDG_DATA_DIRS="${XDG_DATA_DIRS:-$XDG_DATA_HOME:/usr/local/share:/usr/share}"
# Basic PATH prepending (user local bin) - only if not already present
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="$HOME/.local/bin:$PATH"

function set_xdg_user_dir() {
  [[ -n "$2" ]] && typeset -gx "$1=$2"
}

if command -v xdg-user-dir >/dev/null 2>&1; then
  set_xdg_user_dir XDG_DESKTOP_DIR "$(xdg-user-dir DESKTOP 2>/dev/null)"
  set_xdg_user_dir XDG_DOWNLOAD_DIR "$(xdg-user-dir DOWNLOAD 2>/dev/null)"
  set_xdg_user_dir XDG_TEMPLATES_DIR "$(xdg-user-dir TEMPLATES 2>/dev/null)"
  set_xdg_user_dir XDG_PUBLICSHARE_DIR "$(xdg-user-dir PUBLICSHARE 2>/dev/null)"
  set_xdg_user_dir XDG_DOCUMENTS_DIR "$(xdg-user-dir DOCUMENTS 2>/dev/null)"
  set_xdg_user_dir XDG_MUSIC_DIR "$(xdg-user-dir MUSIC 2>/dev/null)"
  set_xdg_user_dir XDG_PICTURES_DIR "$(xdg-user-dir PICTURES 2>/dev/null)"
  set_xdg_user_dir XDG_VIDEOS_DIR "$(xdg-user-dir VIDEOS 2>/dev/null)"
fi
unfunction set_xdg_user_dir

# shade Compositor Environment
if [[ -z "$SHADE_ACTIVATED" ]]; then
  for _shade_activate in \
    "$HOME/.local/lib/shade/shell/activate" \
    "/usr/local/lib/shade/shell/activate" \
    "/usr/lib/shade/shell/activate"; do
    [[ -f "$_shade_activate" ]] && {
      source "$_shade_activate"
      break
    }
  done
  unset _shade_activate
fi

typeset -U PATH
