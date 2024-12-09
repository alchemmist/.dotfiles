#!/usr/bin/env bash

SERVICE_NAME="wg-quick@wg0"
STATUS_CONNECTED_STR='{"text":"Connected","class":"connected","alt":"connected"}'
STATUS_DISCONNECTED_STR='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'

# function askpass() {
#   rofi -dmenu -password -no-fixed-num-lines -p "Sudo password : " -theme ~/.config/waybar/wireguard-manager/rofi.rasi 
# }

function status_wireguard() {
    sudo wg show wg0 &> /dev/null
    return $?
}

function toggle_wireguard() {
  status_wireguard && \
     sudo wg-quick down wg0 || \
     sudo wg-quick up wg0
}

case $1 in
  -s | --status)
    status_wireguard && echo $STATUS_CONNECTED_STR || echo $STATUS_DISCONNECTED_STR
    ;;
  -t | --toggle)
    toggle_wireguard
    ;;
  *)
    askpass
    ;;
esac
