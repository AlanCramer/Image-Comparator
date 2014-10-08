#!/bin/bash

# Typical Usage: 
#    find ../images -name *.jpg | xargs addImagesToDb.sh
#
#
i=0
curlcmd="curl -X PUT http://127.0.0.1:5984/rop_images/"
for arg in $*
do
   i=$((i+1))
   filename=$(cd $(dirname "$arg"); pwd)/$(basename "$arg")
   echo "adding $i : $filename"
   curldata="{\"origin\":\"$filename\"}"
   cmd="$curlcmd$i -d $curldata"
   echo $cmd
   res=$($cmd) 
   echo $res
   IFS='"' read -a array <<< "$res"
   rev=${array[9]}
   imagename="image"
   cmd="$curlcmd$i/$imagename?rev=$rev --data-binary @$arg -H \"Content-Type: image/jpg\""
   echo $cmd  
   res=$($cmd)
done
