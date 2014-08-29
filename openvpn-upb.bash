#!/bin/bash

# Connect to university of Paderborn via VPN.

function print_help
{
    echo "Usage: $0 [up|down]"
}

case "$1" in
    up) nmcli con up id openvpn-upb ;;
    down) nmcli con up id openvpn-upb ;;
    *) print_help ;;
esac
