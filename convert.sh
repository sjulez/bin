#!/bin/bash
# This is a quite slow implementation of an algo which uses the convert-modul
# of the imagemagick-package to resize a bunch of pictures in a Directory.
# As I said, it's slow but I like it =)


# second test-comment
# Check if imagemagick is installed
if [ ! -a /usr/bin/convert ] ; then
   echo "I didn't found the convert-Module at it's standard-install-path \n Assuming imagemagick not to be installed! \n --> Do you want to install it now? (Y/N)"
   read INSTALL
   if [[ $INSTALL -eq {Y|y|J|j|Yes|yes|Ja|ja|ohyeahbabyinstallthatcrazyshitonmycomputernow} ]] ; then
      # this is debian (ubuntu) only
      sudo apt-get install imagemagick
   else
      if [[ $INSTALL -ne {Y|y|J|j} ]] ; then
         echo "Ok, gotta have to exit now and do nothing..." ;
	 exit
      fi
   fi
fi

# i made a comment here to test a git-diff and a commit
# to remember the starting-point (see last if-statement to get the intention)
START=$PWD

# User-Input (Shall those be blessed who are able to read and respond to the computer)
echo "Please Enter the path to the Directory (Subdir of your Home-Dir without leading and finishing slash)\n"
read DIR

echo "Please Enter the resolution (e.g. 1280x960) of the written files \n"
read RES

echo "Please enter the quality (0-100) for the convertion-process \n"
read QUALITY

# Skript runs from Home-Directory
if [ $PWD -ne $HOME ] ; then
   echo "switching to Home-Directory..."
   # see last if-statement for why i do this...
   switch=1
   cd
fi

# Getting the Numbers of files to be processed
a=$(( `ls -l $HOME/$DIR/*.[JPG|jpg|jpeg|png] | wc -l` ))
echo "Starting convertion of $a pictures"

# counter has to be initialized before starting the loop
count=0
for i in $HOME/$DIR/*.JPG; do
   j=${i//\.[JPG|jpg|jpeg|png]/}
   convert -resize $RES -quality $QUALITY $HOME/$DIR/$i $HOME/$DIR/${j}_klein.png
   #  Abort as Error is thrown by convert
   if [ $? -ne 0 ] ; then
      exit
   fi
   count=$(($count+1))
   percent=$(($count*100/$a))
   #  don't display the status line-by-line, refresh it!
   clear; echo "converted $count from $a --> $percent % "
done

# Error-Handling ( Uhh-Yeah! )
if [ $? -eq 0 ] ; then
   # check for output directory and move the images
   if [ -d $HOME/$DIR/kleiner ] ; then
      mv $HOME/$DIR/*_klein.png $HOME/$DIR/kleiner
   else
      mkdir $HOME/$DIR/kleiner
      mv $HOME/$DIR/*_klein.png $HOME/$DIR/kleiner
   fi
   echo "Converted $count Files and moved them to the subdirectory \/kleiner "
else
   echo "Errors occurred during the convert-process"
fi

if [ $switch -eq 1 ] ; then
   echo "Return to Directory where I've been started from..."
   # no error-handling needed for this one - works everytime ;-)
   cd $START
fi
