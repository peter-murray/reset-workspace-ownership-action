#!/bin/sh -l

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

echo "Updating ownership permissions on directory: $1"
echo "  user: $2"

# The current working directory in the container is the workspace we need to check and modify
ls -la .

echo
echo "Looking for files/directories in current working directory not owned by \"$2\""
echo
find . ! -user $2 -exec $SCRIPT_PATH/update_file_object.sh "{}" "$2" \;