#!/bin/bash

# Taken from
# http://askubuntu.com/questions/1792/how-can-i-suspend-hibernate-from-command-line

dbus-send --system --print-reply \
    --dest="org.freedesktop.UPower" \
    /org/freedesktop/UPower \
    org.freedesktop.UPower.Suspend
