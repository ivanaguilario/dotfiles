if [ -z "${SSH_CONNECTION-}" ] && [ -z "${SSH_TTY-}" ] \
   && [ -z "${WAYLAND_DISPLAY-}" ] && [ -z "${DISPLAY-}" ] \
   && [ "${XDG_VTNR-}" -ge 1 ] 2>/dev/null; then
  exec start-hyprland
fi
