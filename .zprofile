#
# ~/.zprofile
#

export XDG_CURRENT_DESKTOP=KDE

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi

