#!/bin/bash

# compare two sets of CSV files for changes
# Script will alert to differences greater than 10% between old and new files
# Usage: bspace_compare ZipOne.zip ZipTwo.zip

set -e

DELTA_THRESHOLD=10

OLD_ZIP=$1
NEW_ZIP=$2

TEMP_DIR=$(mktemp -d)
echo $TEMP_DIR
#TEMP_DIR=./temp
OLD=$TEMP_DIR/old
NEW=$TEMP_DIR/new

echo "Comparing $OLD_ZIP and $NEW_ZIP zip files"


mkdir -p $OLD
mkdir -p $NEW

echo "decompressing $OLD_ZIP, $NEW_ZIP"
unzip -q -o -d ${OLD} $OLD_ZIP
unzip -q -o -d ${NEW} $NEW_ZIP

echo "sorting files"

for i in $OLD $NEW
do
  for f in $i/*.csv
  do
    sort -o $f $f
  done
done

echo "checking for differences"

OLD_LIST=( $( ls $OLD/*.csv ) )
NEW_LIST=( $( ls $NEW/*.csv ) )

for i in "${!OLD_LIST[@]}"
do
  DELTA=$(comm -3 ${OLD_LIST[$i]} ${NEW_LIST[$i]} | wc -l)
  OLD_COUNT=$(wc -l < ${OLD_LIST[$i]})
  NEW_COUNT=$(wc -l < ${NEW_LIST[$i]})

  LARGER=$(( $OLD_COUNT >= $NEW_COUNT ? $OLD_COUNT : $NEW_COUNT  ))
  PCT_DELTA=$(echo "$DELTA/$LARGER*100" |bc -l)

  echo "$(basename ${OLD_LIST[$i]}) --> $(basename ${NEW_LIST[$i]})"
  if (( $(bc -l <<<"$PCT_DELTA > $DELTA_THRESHOLD") ))
  then
    echo "*******WARNING!******"
    printf "   %.2f%% change in %s\n" "$PCT_DELTA" "$OLD_LIST[$i]"
  else
    echo "   OK"
  fi
  echo " "
done

rm -rf $TEMP_DIR
