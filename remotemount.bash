#!/bin/bash

#############
# Constants #
#############
readonly REMOTEMACHINE="ntws15"
readonly MOUNTDIR="/home/${USER}/ntwsmounts"
declare -Ar REMOTE=(\
    [speechdb]=ntws15:/net/speechdb \
    [ntwshome]=ntws15:/net/home/mpuels \
    [netvol]=ntws15:/net/vol/mpuels \
    [gethome]=get1:/home/mpuels \
    [geteda]=get1:/eda \
    )
                    
###############################
# Input dependenant Variables #
###############################
COMMAND=()
# The remote the user wants to mount/unmount. E.g. "speechdb".
ARGREMOTE="UNSET"
SHOW_HELP="FALSE"

####################
# Argument Parsing #
####################
# Parsing of arguments adapted from an example for getopt in
# /usr/share/doc/util-linux/examples/getopt-parse.bash .

ARGS=`getopt -o chlm:u: \
             -n 'mountntws.sh' -- "$@"`

# Terminate, if the user gives an unknown argument.
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$ARGS"

while true; do
  case "$1" in
    -c)  COMMAND+=("LIST_CURR"); shift ;;
    -h)  SHOW_HELP="TRUE"; shift ;;
    -l)  COMMAND+=("LIST_AVAI"); shift ;;
    -m)  COMMAND+=("MOUNT"); ARGREMOTE="$2"; shift 2 ;;
    -u)  COMMAND+=("UMOUNT"); ARGREMOTE="$2"; shift 2 ;;
    --) shift; break ;;
  esac
done

usage() {
cat <<EOF
  $(basename $0) (-m|-u) remote
  $(basename $0) -c
  $(basename $0) -l
  $(basename $0) -h

  The mount point remote is mounted, if the option -m is set. It is unmounted,
  if the option -u is set.

  -c    List currently mounted remotes.
  -l    List available remotes, which can be mounted.
  -h    Print this help message.
EOF
}

if [[ "$SHOW_HELP" = "TRUE" ]]; then
  usage
  exit 0
fi

if [[ ${#COMMAND[@]} -eq 1 ]]; then
  COMMAND=${COMMAND[0]}
else
  echo "Exactly one command has to be given."
  echo
  usage
  exit 1
fi

# Check, if remote $1 is in the list REMOTE.
# $1: The remote to check, e.g. "netvol".
# RETURN: 0, if $1 is in the list, 1 otherwise.
is_in_remote_list() {
  local remote_="$1"
  for k in "${!REMOTE[@]}"; do
    if [[ "${REMOTE["$k"]}" != "" ]]; then
      return 0
    fi
  done
  return 1
}

case "$COMMAND" in
  MOUNT)
    is_in_remote_list "$ARGREMOTE"
    if [[ $? -eq 0 ]]; then
      url="${USER}@${REMOTE[$ARGREMOTE]}"
      mountpoint="${MOUNTDIR}/${ARGREMOTE}"
      mkdir -p "${mountpoint}"
      sshfs "${url}" "${mountpoint}"
      if [ $? -eq 0 ]; then
        echo Mounted $url on $mountpoint
      else
        echo Mounting of $url failed.
      fi
    else
      echo "Remote $ARGREMOTE not found. Try option -l to list available remotes."
    fi ;;
  UMOUNT)
    echo "Unmounting ${MOUNTDIR}/${ARGREMOTE}"
    fusermount -u "${MOUNTDIR}/${ARGREMOTE}" ;;
  LIST_CURR)
    echo "Currently mounted remotes:"
    df \
    | grep "^${USER}@" \
    | while read line; do
      remotename=$(basename $(echo $line | awk '{print $6}'))
      s=$(echo $line | awk '{print $1 " -> " $6}')
      echo $remotename: $s
      done ;;
  LIST_AVAI)
    echo "Remotes available for mounting:"
    for k in "${!REMOTE[@]}"; do
      echo $k: "${USER}@${REMOTE[$k]}" "->" \
           "${MOUNTDIR}/${k}"
    done ;;
  *)
    echo "Fatal error: Unknown command $COMMAND."
    exit 1 ;;
esac

exit 0
