#!/usr/bin/env bash

# source files to be zipped and sent
SOURCE="C:\\BrightSpace\\Exports\\"
# area to queue up the exports prior to zipping
DEST="C:\\BrightSpace\\SFTP_queue"
# zipped file
ZIPFILE="C:\BrightSpace\export.zip"

# Manifest file to include
MANIFESTJSON='{ "version":"2.0" }'
MANIFESTFILE="manifest.json"
SFTPSITE="sftp://eu01pipsissftp.brightspace.com"
SFTPUSER="sftp-ash-0a8b"
SFTPPASS="enter password here"



# remove everythig in the destination location
rm -rf $DEST\\*
# move the most recent export into the destination
mv $SOURCE\*.csv $DEST
# create the manifest.json file
echo $MANIFESTJSON > $DEST\\$MANIFESTFILE
zip $ZIPFILE $SOURCE\\*.csv
sftp $SFTPUSER:SFTPPASS@$SFTPSITE
rm $ZIPFILE

