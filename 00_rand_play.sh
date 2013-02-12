#!/bin/bash
# ---------------------------------------------------
# | if you have a large folder of mp4-files and you |
# | you can't decide which one to watch, just use   |
# | this script... have fun... ;-)                  |
# | It uses vlcplayer to run                        |
#sudo apt-get install vlc
# ---------------------------------------------------
vlcinstall=$(which vlc)

if [ -n "$vlcinstall" ] ; then
  if [ -n "$1" ]; then
    #How many files are in the folder?
    max=$(ls -l $1*.mp4 | wc -l)

    #Store the list of filenames
    liste=$(ls $1*.mp4)

    nr=$((RANDOM % $max +1))

    #parse the argument for vlc
    start=file://$(echo $liste | awk -v dat=$nr '{print $dat}')

    #start vlc
    vlc -f $start
  else
    echo "You have to enter the Folder to search in as an argument"
  fi
else
  echo "Please install vlc to run this script"
fi
