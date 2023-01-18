#!/bin/sh -l

if [[ -z "$1" ]]; then
    echo "File or Directory has not been specified"
    exit 1
fi

if [[ -z "$2" ]]; then
    echo "User id or name has not been specified"
    exit 2
fi

echo "Updating ownership: $1"
echo "  `ls -lad $1`"
chown -cvf $2 "$1"
echo "Modified ownership: $1"
echo "  `ls -lad $1`"
echo
