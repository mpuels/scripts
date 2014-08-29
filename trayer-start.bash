#!/bin/bash

# TODO: Check, if trayer is already running.
trayer \
    --edge top \
    --align right \
    --SetDockType true \
    --SetPartialStrut true \
    --expand true \
    --width 10 \
    --transparent true \
    --tint 0x191970 \
    --height 12 &

dropbox start

# TODO: Check, if nm-applet is already running.
#nm-applet --sm-disable &
