#!/bin/bash

# compare two sets of CSV files for changes
# Script will alert to differences greater than 10% between old and new files
# Usage: bspace_compare ZipOne.zip ZipTwo.zip

set -e

VERSION="Version 2.0_2023.03.02"

DELTA_THRESHOLD=5

OLD_ZIP=$1
NEW_ZIP=$2

TEMP_DIR=$(mktemp -d)
echo $TEMP_DIR
#TEMP_DIR=./temp
OLD=$TEMP_DIR/old
NEW=$TEMP_DIR/new

echo $VERSION

echo "Comparing $OLD_ZIP and $NEW_ZIP zip files"


mkdir -p $OLD
mkdir -p $NEW

echo "decompressing into $TEMP_DIR"
unzip -q -o -d ${OLD} ${OLD_ZIP}
unzip -q -o -d ${NEW} ${NEW_ZIP}

echo "Comparing CSVs from $(basename $OLD_ZIP) and $(basename $NEW_ZIP)
"

# glob the old and new files
OLD_LIST=( $( ls $OLD/*.csv ) )
NEW_LIST=( $( ls $NEW/*.csv ) )

# create a place to stash non-matching "old" files
NO_MATCH_OLD=()

# loop through the "old" files 
for i in "${!OLD_LIST[@]}"
do
  MATCH=0

  # set the basename and regex extract the filename and remove date stamp
  # expected format:8-Enrollments_201_students_school-2023-03-01.csv
  # .*(-d%|-\d{4}.csv)
  OLD_PATH=${OLD_LIST[$i]}
  OLD_BASENAME=$(basename ${OLD_PATH})
  OLD_FN=$(echo $OLD_BASENAME | sed -E -E 's/(.*)(-%d|-[[:digit:]]{4}-.*).csv/\1/' )

  # loop through existing list and try to find matches
  for j in "${!NEW_LIST[@]}"
  do
    NEW_PATH=${NEW_LIST[$j]}
    NEW_BASENAME=$(basename ${NEW_PATH})
    NEW_FN=$(echo $NEW_BASENAME | sed -E -E 's/(.*)(-%d|-[[:digit:]]{4}-.*).csv/\1/' )

    # try to match new/old filenames
    if [[ ${NEW_FN} = ${OLD_FN} ]] 
    then
      MATCH=1
      NEW_MATCH_PATH=${NEW_PATH}
      # echo "breaking out because we found a match. j=$j"
      break
    fi
  done


    if [[ $MATCH -gt 0 ]] 
    then
      # pop the matching item from the NEW_LIST
      unset NEW_LIST["$j"]
      
      # total number of lines in old and new file
      OLD_LINES=$(cat $OLD_PATH | wc -l)
      NEW_LINES=$(cat $NEW_MATCH_PATH | wc -l)
      # difference between the old and new files
      DELTA_LINES=$( echo "scale=0; sqrt(($OLD_LINES - $NEW_LINES)^2)" | bc -l )
      # compare the difference with the "old" file (assuming the old is good)
      DELTA_PCT_OLD=$( echo "scale=3; ($DELTA_LINES/$OLD_LINES)*100" | bc -l )
      # get the lines that are in common between the old and new file
      COMMON=$( comm -12 <(sort ${OLD_PATH}) <(sort ${NEW_MATCH_PATH}) |wc -l)
      # lines that are unique to the NEW file
      NEW_UNIQUE=$( comm -13 <(sort ${OLD_PATH}) <(sort ${NEW_MATCH_PATH}) | wc -l )
      # lines that are unique to the OLD file
      OLD_UNIQUE=$( comm -23 <(sort ${OLD_PATH}) <(sort ${NEW_MATCH_PATH}) | wc -l )
      # total "uniqueness" value
      TOTAL_UNIQUE=$(( NEW_UNIQUE + OLD_UNIQUE ))
      # compare the difference with the OLD file
      UNIQUE_PCT_CHANGE=$( echo "scale=3; ($TOTAL_UNIQUE/$COMMON)*100" | bc -l )

      echo "checking $NEW_FN..."

      # check the delta percentages for the total number of lines or total uniqueness
      if  (( $(echo "$DELTA_PCT_OLD >= $DELTA_THRESHOLD" |bc -l) || $(echo "$UNIQUE_PCT_CHANGE >= $DELTA_THRESHOLD"|bc -l) ))
      then
        echo "*****************WARNING****************"
        echo "change threshold exceeded:"
        echo "$OLD_FN statistics:"
        echo "OLD_LINES: $OLD_LINES, NEW_LINES: $NEW_LINES"
        echo "LINES DELTA: $DELTA_LINES, LINES PCT CHANGE: $DELTA_PCT_OLD"
        echo "OLD_UNIQUE: $OLD_UNIQUE, NEW_UNIQUE: $NEW_UNIQUE, TOTAL UNIQUE: $TOTAL_UNIQUE"
        echo "UNIQUE_PCT_CHANGE: $UNIQUE_PCT_CHANGE"
        echo 
        echo " "
        echo " "
    else
      echo "OK
      
      "
    fi
  else
    # reocrd the "old" files that don't have a match
    echo "no match for $OLD_FN"
    echo " "
    echo " "
    NO_MATCH_OLD+=${OLD_PATH}
  fi
done

# report on the old/new files that were not matched and checked
for i in "${!NO_MATCH_OLD[@]}"
do
  echo "**************WARNING***************"
  echo "No matching file in the $OLD_ZIP was found for file:"
  echo "$OLD_ZIP: $(basename ${NO_MATCH_OLD[$i]})"
done

for i in "${!NEW_LIST[@]}"
do
  echo "No matching file in the $NEW_ZIP was found for file:"
  echo "$NEW_ZIP: $(basename ${NEW_LIST[$i]})"
done
# echo "NO MATCH OLD: ${NO_MATCH_OLD[@]}"
# echo "NO MATCH NEW: ${NEW_LIST[@]}"

# clean up
rm -rf $TEMP_DIR
