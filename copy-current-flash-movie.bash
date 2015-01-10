#!/bin/bash

# Kopiere ein gerade gestreamtes Video in eine Datei.
#
# Wird ein Flash-Video in Firefox geöffnet,
# so legt das Flash-Plugin eine lokale, temporäre Datei an,
# in der der Videoinhalt abgelegt ist.
# Diese Datei wird jedoch sofort wieder vom Plugin gelöscht,
# damit man nicht darauf zugreifen kann.
#
# Mit dem Befehl `lsof` können jedoch alle zur zeit offenen file descriptors
# angezeigt werden.
# Dieses Script nutzt das aus und kopiert das gerade in Firefox geöffnete Video
# in die Datei $SWF_FILE_DEST.
#
# Nutzung: Wird der Befehl
#
#     $ copy-current-flash-movie.bash
#
# ausgeführt, kann das kopierte Video in $SWF_FILE_DEST abgeholt werden.

#OPEN_FLASH_FILE_LINE="plugin-co 6936 mpuels 19u REG 8,1 143228557 4068553 /tmp/FlashXXw3lGuN (deleted)"
OPEN_FLASH_FILE_LINE=$(lsof | grep Flash | head -n1)

PLUGIN_PID=$(cut -f2 -d' ' <<< $OPEN_FLASH_FILE_LINE)
FILE_DESCRIPTOR=$(cut -f4 -d' ' <<< $OPEN_FLASH_FILE_LINE | sed 's/u//g')
SWF_FILE=/proc/$PLUGIN_PID/fd/$FILE_DESCRIPTOR

SWF_FILE_DEST=/tmp/movie.swf

function main
{
    echo \$OPEN_FLASH_FILE_LINE: $OPEN_FLASH_FILE_LINE
    echo \$PLUGIN_PID: $PLUGIN_PID
    echo \$FILE_DESCRIPTOR: $FILE_DESCRIPTOR
    echo \$SWF_FILE: $SWF_FILE
    echo \$SWF_FILE_DEST: $SWF_FILE_DEST

    echo Copying \$SWF_FILE to \$SWF_FILE_DEST
    cp $SWF_FILE $SWF_FILE_DEST
    echo Done.
    ls -lh $SWF_FILE_DEST
}

main
