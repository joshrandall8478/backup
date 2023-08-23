#!/bin/bash

# command: cleanup.sh /target-dir "date-adjuster"
# Examples of date adjusters:
# "-90 days"
# "-1 minute"

if ! [ $(id -u) = 0 ]; then
   echo "The script needs to be run as root." >&2
   exit 1
fi

if [ "$1" = "" ] || [ "$2" = "" ]; then
        echo "Invalid usage, use -h for more info"
        exit
fi

if [[ ! "$2" == *"-"* ]] || [[ ! "$2" == *" "* ]]; then
	echo "Invalid date-adjuster usage"
	echo ""
	echo "Correct syntax examples:"
	echo "-30 minutes"
	echo "-2 weeks"
	exit
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage:"
	echo "./cleanup.sh /target-dir $(echo '"date-adjuster"')"
	echo ""
	echo "Examples of date adjusters:"
	echo '"-90 days"'
	echo '"-1 minute"'
        exit
fi



currentDate=$(date +%Y-%m-%d-%H%M%S)

currentDir=$(pwd)
cd $1
targetDir=$(pwd)
cd "$currentDir"
dateAdjuster="$2"

echo "Current date: $currentDate"
echo "cleanup.sh will delete any backup in '$targetDir' older than: $(echo $dateAdjuster | tr -d '-')"
cd "$targetDir"

if [[ ! "$(ls .)" == *".tar.gz"* ]]; then
	echo "There are no archives in the destination directory."
	exit
fi
for archive in *; do
	if [[ ! "$archive" == *".tar.gz"* ]]; then
		echo "Archives must be .tar.gz files"
		exit
	fi
	archiveName=$(echo "${archive%.*.*}" | tr -d '-') 	
	if [ $(date -d "$dateAdjuster" +%Y%m%d%H%M%S) -gt $(expr $archiveName + 0) ]; then
		rm $archive
		echo "$archive deleted"
	fi
done

echo "Script complete"
