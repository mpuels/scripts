#!/bin/bash

# Increase or decrease the volume of the current audio device.
#
# Usage: changeVolume.bash DIRECTION
# Where DIRECTION is either + or -.
#
# If the Logitech G930 Headset is connected,
# this script changes the volume of that device.
# Otherwise it changes the volume of the internal sound card.

readonly DELTA_VOLUME="3%"

function main
{
    local direction=$1

    local cardNumberLogitech=$(maybeGetCardNumberOfLogitechHeadset)
    case $cardNumberLogitech in
	"") changeVolumeOfLoudspeakers $direction ;;
	*) changeVolumeOfHeadphones $direction ;;
    esac
}

function maybeGetCardNumberOfLogitechHeadset
{
    aplay -l \
	| grep 'Logitech G930 Headset' \
	| sed 's/^Karte \([0-9]\): .\+$/\1/g'
}

function changeVolumeOfLoudspeakers
{
    local direction=$1
    case $direction in
	+|-) amixer -q -c 0 sset Master ${DELTA_VOLUME}$direction ;;
	*) ;;
    esac
}

function changeVolumeOfHeadphones
{
    local direction=$1
    case $direction in
	+|-) amixer -q -c 1 sset PCM ${DELTA_VOLUME}$direction ;;
	*) ;;
    esac
}

main $@
