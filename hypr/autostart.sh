#!/bin/bash

# Só lança se não existir já um session bus
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  dbus-launch --sh-syntax --exit-with-session > ~/.dbus-session-vars
fi

# Exporta as variáveis do arquivo para o ambiente atual
source ~/.dbus-session-vars

eww open bar &
hyprctl setcursor 'WinSur' 24 &
hyprpaper &
pipewire &
pipewire-pulse &
wireplumber &
wlsunset -S 4:40 -s 17:30 -t 3500 &
udiskie &
#gammastep -O 5400K &

