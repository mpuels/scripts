#!/bin/bash

function main
{
    if [ "$(trayerIsRunning)" == false ]; then
        echo starting trayer
        start_trayer
    fi

    if [ "$(nmappletIsRunning)" == false ]; then
        echo starting nm-applet
        start_nmapplet
    fi

    start_dropbox
}

function trayerIsRunning
{
    daemonIsRunning trayer
}

function start_trayer
{
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
}

function start_dropbox
{
    dropbox start
}

function nmappletIsRunning
{
    daemonIsRunning nm-applet
}

function start_nmapplet
{
    nm-applet --sm-disable &
}

function daemonIsRunning
{
    local progName=$1
    local nInstances=$(ps -C $progName \
        | grep -v "PID TTY" \
        | wc -l)

    if [ $nInstances -gt 0 ]; then
        echo true
    else
        echo false
    fi
}

main
