#!/bin/bash

# command: ./backup.sh /backup-dir /destination-dir


if [ "$1" = "" ] || [ "$2" = "" ]; then
	echo "Invalid usage, use -h for more info"
	exit
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	echo "Usage:"
	echo "./backup.sh /backup-dir /destination-dir"
	exit
fi

currentDate=$(date +%Y-%m-%d-%H%M%S)

currentDir=$(pwd)
cd "$1"
backupDir=$(pwd)
cd "$currentDir"
cd "$2"
destination=$(pwd)
echo "Directory to backup: $backupDir"
echo "Backup destination: $destination"

echo "Starting backup..."

if [ ! -f /usr/bin/tar ]; then
	echo "tar is not installed, cannot continue."
	exit;
fi
cd "$currentDir"
cd "$backupDir"
fileName="$currentDate.tar.gz"
tar -czvf $fileName *
mv $fileName "$destination"
echo "Backup complete!: $currentDate.tar.gz"
