#!/bin/sh -l

echo "Updating ownership permissions on directory: $1"
echo "  user: $2"

# The current working directory in the container is the workspace we need to check and modify
ls -la .