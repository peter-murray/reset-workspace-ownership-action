#!/bin/sh -l

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

export USER_UID=$1

echo "Updating ownership permissions on workspace directory ${2}"
echo "  user: $USER_UID"

# The current working directory in the container is the workspace we need to check and modify
ls -la .

echo
echo "Looking for files/directories in current working directory not owned by \"$USER_UID\""
echo
find . ! -user $USER_UID -exec $SCRIPT_PATH/update_file_object.sh "{}" "$USER_UID" \;