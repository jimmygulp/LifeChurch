#!/bin/bash

# We like spaces in file names...
IFS=$'\n'

# Input Directory
INPUT='/mnt/BigBackup/2019'

#Output Directory
OUTPUT='/mnt/Content/Groups/Media/ConvertedRecordings/2019'

# Move to the 2018 Directory on BigBackup
cd $INPUT

# Check if there are any new directories, and create them in the H264 output folder. Saves HandbrakeCLI having a cry
echo "Making Output Directories..."
for i in `find -type d` ; do mkdir -p $OUTPUT/$i ; done

# Find files created in the last 24hours that end with .mov (For some reason, find's -ctime has stopped working, so we'll just find everything, we won't process them all, see later)
echo "Finding files..."
for file in `find . -name *.mov | grep -v thumb` ; do

# Check if the output file exists (ie, have we already processed it?) - If not, run HandBrakeCLI using the LCH preset, renaming .mov to .m4v
echo "Processing files... Please wait..."
if [ ! -f "$OUTPUT/${file%.mov}.m4v" ]; then
	HandBrakeCLI --preset-import-gui -Z "LCH" -T -i "$file" -o "$OUTPUT/${file%.mov}.m4v" ;
else
	echo "File Exists, skipping"
fi
done

# And we're done. Now for a brew.

