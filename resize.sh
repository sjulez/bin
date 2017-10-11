#!/bin/bash
a=$(((`ls | wc -l`) - 1)) 
echo "Starting convertion of $a pictures"
echo "Pictures will get a watermark"
count=0
for i in *.JPG; 
do
   j=${i//\.JPG/}
   convert -resize 2560x1920 -quality 90 $i ${j}_small.JPG
#   composite -watermark 40% -gravity southeast $HOME/Pictures/julesphoto_watermark.jpg ${j}_small.JPG ${j}_small_wm.JPG
   count=$(($count+1))
   percent=$(($count*100/$a))
   clear; echo "converted $count from $a --> $percent % "
done
mkdir kleiner
#mv *_small_wm.JPG kleiner
mv *_small.JPG kleiner
#rm -r *.small.JPG
if [ $?==0 ] ; then
   echo "Converted $count Files and moved them to the subdirectory \/kleiner "
else
   echo "Errors occurred during the convert-process"
fi
