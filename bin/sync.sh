#!/bin/bash

# un-official strict mode
set -euo pipefail

_term() {
  echo "Final Sync of files"
  /usr/local/bin/unison sync
  exit
}

trap _term SIGTERM SIGKILL

export QUIET_PERIOD=${QUIET_PERIOD:-30}
export VOLUME=${VOLUME:-wordpress}

echo "quiet period: $QUIET_PERIOD"

inotifywait_events="modify,attrib,move,create,delete"

perl -pi -e "s!wordpress!$VOLUME!g" /root/.unison/initialsync.prf
perl -pi -e "s!wordpress!$VOLUME!g" /root/.unison/sync.prf

echo "Initial Sync"
cat /root/.unison/sync.prf
/usr/local/bin/unison initialsync

echo "watching for changes..."
while inotifywait -r -e $inotifywait_events /app/wp-content ; do
  echo "Change detected..."
  while inotifywait -r -t $QUIET_PERIOD -e $inotifywait_events /app/wp-content ; do
    echo "waiting for quiet period..."
  done

  echo "starting sync..."
  /usr/local/bin/unison sync
  echo "sync complete."
done
