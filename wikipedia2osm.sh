#!/bin/bash
# Script by Bassem JARKAS
# V0.1 22 November 2009
# TODO:
# - remove source wikipedia and other fake tags
# - avoid duplicated name:ar
# - add output option
# - Continue after network problems
# - search in other wikipedias (wikipedia:fr, wikipedia:ru, ...)
# - handle http wikipedia url
# - Clean the code
# - Better documentation and comments
# - add the other languages
# - adding log (notice, error)
# - find the article from other tags if no wikipedia tag available
# - calculate the time
# - Download input data direct from the internet
# - fix removing wikipedia:xx

# Clean the files
rm Capitalll.osm

#input file
INPUT=$1

# Read the file and put it in lines
cat $INPUT | while read line; do
  # Check if the line has the work wikipedia, if not just write it to the output
  echo $line |  grep  wikipedia  > /dev/null
  # if yes, print the line + ok
  if test "$?" -eq 0  ; then
    NAME=`echo $line |  grep -v wikipedia:   | sed 's/^<.*v=\(.*\) \/>$/\1/'  | tr -d "\'" | tr " " "_"`
    # check wikipedia website for the article and find the arabic name
    for ART_EN in $NAME 
      do
      URL="http://en.wikipedia.org/w/api.php?action=query&prop=revisions&titles=$ART_EN&export"
      wget $URL -O $ART_EN 
      ART_AR=`grep "\[\[ar:" $ART_EN | sed 's/^\[\[ar:\(.*\)\]]/\1/'`
      # Notice if no arabic found
      if [ "$ART_AR" ] ; then
        # Write the arabic name in osm tag
        echo "    <tag k='name:ar' v='$ART_AR' />" >> Capitalll.osm
        echo "    $line" >> Capitalll.osm
      else 
        echo "NOTICE: Arabic not found"
        echo "    $line" >> Capitalll.osm
      fi
      # Remove downloaded files
      rm $ART_EN
    done
   # if no, print only the line
  else
  # fix indent
    echo $line |  egrep  "</*node"  > /dev/null
    node_exit="$?"
    echo $line |  grep  "<tag"  > /dev/null
    tag_exit="$?"
    echo $line |  grep  "<member"  > /dev/null
    member_exit="$?"
    echo $line |  grep  "</*relation"  > /dev/null
    relation_exit="$?"
    if test "$node_exit" -eq 0  ; then
      echo "  $line" >> Capitalll.osm
    elif test "$tag_exit" -eq 0  ; then
      echo "    $line" >> Capitalll.osm
    elif test "$member_exit" -eq 0  ; then
      echo "    $line" >> Capitalll.osm
    elif test "$relation_exit" -eq 0  ; then
      echo "  $line" >> Capitalll.osm
    else
      echo $line >> Capitalll.osm
    fi
  fi
# end of while
done 

exit 0
