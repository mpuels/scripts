#!/bin/bash

# sawoti (Super Awesome Workout Timer)

SCRIPTDIR=$(dirname $(readlink -f $0))
WHISTLE_SND_PATH=${SCRIPTDIR}/trillerpfeife.mp3
COUNTDOWN_SECS=3
TRAINING_TIME_SEC=20
PAUSE_TIME_SEC=10
N_REPETITIONS=4

function blow_whistle
{
    play -q $WHISTLE_SND_PATH trim 0 0:00.5
}

function print_progress_bar
#unction print_progress_bar $n_secs $symbol
{
    local n_secs="$1"
    local symbol="$2"

    for n in $(seq $n_secs); do
	echo -n $symbol
	sleep 1
    done
    echo
}

function do_workout
#unction do_workout $n_secs
{
    local n_secs="$1"
    print_progress_bar $n_secs "#"
}

function do_pause
#unction do_pause $n_secs
{
    local n_secs="$1"
    print_progress_bar $n_secs "."
}

function do_countdown
#unction do_countdown $startTime
{
    local startTime="$1"
    for count in $(seq $startTime -1 1); do
	echo -n "$count "
	sleep 1
    done
    echo "=> !GO!"
}

function main
{
    do_countdown $COUNTDOWN_SECS
    for rep in $(seq 1 $N_REPETITIONS); do
	echo "$rep / $N_REPETITIONS"
	blow_whistle &
	do_workout $TRAINING_TIME_SEC
	blow_whistle &
	if [ $rep -lt $N_REPETITIONS ]; then
	    do_pause $PAUSE_TIME_SEC
	fi
    done
    echo
}

main
