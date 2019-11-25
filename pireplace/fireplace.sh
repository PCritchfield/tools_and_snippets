#! /bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

# get rid of the cursor so we don’t see it when videos are running
setterm -cursor off

# set here the path to the directory containing your videos
VIDEOPATH="$SCRIPTPATH/video"

# you can normally leave this alone
if [ `uname -m` = "x86_64" ]; then
  SERVICE="mpv"
  OPTIONS="--fs"
fi

if [ `uname -m` = "armv7l" ]; then
  SERVICE="omxplayer"
  OPTIONS="-r"
fi


# now for our infinite loop!
while true; do
  if ps ax | grep -v grep | grep $SERVICE > /dev/null
  then
    sleep 1;
  else
    for entry in $VIDEOPATH/*
      do
        clear
        $SERVICE $OPTIONS $entry > /dev/null
	read input
	  if [ $input = "q" ] || [ $input = "Q" ]
          then 
            break
          fi
      done
  fi
done
