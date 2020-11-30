#!/bin/sh -l

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

echo "Updating ownership permissions on workspace directory ${2}"
echo "  user: $1"

# The current working directory in the container is the workspace we need to check and modify
ls -la .

echo
echo "Looking for files/directories in current working directory not owned by \"$1\""
echo
find . ! -user $2 -exec $SCRIPT_PATH/update_file_object.sh "{}" "$1" \;