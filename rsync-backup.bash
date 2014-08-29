#!/bin/bash

function main
{
    BACKUPROOT="/media/mpuels/TOSHIBA EXT/backup"
    if [ ! -d "$BACKUPROOT" ]; then
        echo "Backup destination does not exist:"
        echo "$BACKUPROOT"
        exit -1
    fi

    SOURCE=/home/mpuels

    rsync \
        -aPuE \
        --stats \
        --delete \
        --exclude='.cache/' \
        --exclude='.compiz/' \
        --exclude='.config/' \
        --exclude='.dropbox/' \
        --exclude='.dropbox-dist/' \
        --exclude='.gconf/' \
        --exclude='.gnome/' \
        --exclude='.local/' \
        --exclude='.mozilla/' \
        --exclude='.pki/' \
        --exclude='.bash_history' \
        $SOURCE "$BACKUPROOT"

    # -a fasst folgende Optionen zusammen:
    #     -r kopiert Unterverzeichnisse
    #     -l kopiert symbolische Links
    #     -p behält Rechte der Quelldatei bei
    #     -t behält Zeiten der Quelldatei bei,
    #     -g behält Gruppenrechte der Quelldatei bei
    #     -o behält Besitzrechte der Quelldatei bei (nur root)
    #     -D behält Gerätedateien der Quelldatei bei (nur root)
    #
    # -P fasst folgende Optionen zusammen:
    #     --progress Fortschrittsanzeige beim Transfer anzeigen
    #     --partial Fortsetzung des Transfers bei Abbruch
    #
    # -u überspringt Dateien, die im Ziel neuer sind als in der Quelle
    #
    # -E behält die Ausführbarkeit von Dateien bei
    #
    # --stats zeigt einen ausführlicheren Report am Ende einer Übertragung an.
    #
    # --delete vergleicht Quellverzeichnisse und Zielverzeichnisse
    #     und sorgt dafür, dass Dateien, die im Quellverzeichnis nicht
    #     (mehr) vorhanden sind, im Zielverzeichnis gelöscht
    #     werden. Dies kann dazu führen, das man ungewollt Dateien
    #     löscht, die man aber noch in der Sicherung behalten möchte.
}

main
