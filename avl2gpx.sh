#!/bin/bash
FILE="$1"
OUT="$FILE.gpx"

rm $OUT

# write xml header
echo "<?xml version='1.0' encoding='UTF-8'?>"  >> $OUT
echo "<gpx version='1.1' creator='GPSMID' xmlns='http://www.topografix.com/GPX/1/1'>" >> $OUT
echo "<trk>"  >> $OUT
echo "<trkseg>" >> $OUT

# proccess the data
cat $FILE | while read line ; do 

lat=`echo $line | awk -F, '{ print $1 }'`
lon=`echo $line | awk -F, '{ print $2 }'`
timestamp=`echo $line | awk -F, '{ print $5 }'`

date=`date -d @$timestamp +%FT%TZ`

# write the data
echo  "<trkpt lat='$lat' lon='$lon' >"  >> $OUT
echo  "<time>$date</time>"  >> $OUT
echo "</trkpt>"  >> $OUT

done

# write xml footer
echo  "</trkseg>"  >> $OUT
echo  "</trk>"  >> $OUTecho  "</gpx>"  >> $OUT

exit 0

