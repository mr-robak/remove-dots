#!/bin/bash

# Get the target directory or use the current directory
DIR=${1:-.}

# Verify the directory exists
if [[ ! -d "$DIR" ]]; then
    echo "Error: The specified path is not a directory."
    exit 1
fi

# Iterate over all folders in the directory
echo "Scanning for folders with dots in their names in: $DIR"
for FOLDER in "$DIR"/*/; do
    # Strip the trailing slash
    FOLDER=${FOLDER%/}

    # Check if it's a directory
    if [[ -d "$FOLDER" ]]; then
        BASENAME=$(basename "$FOLDER")
        
        # Check if the folder name contains dots
        if [[ "$BASENAME" == *.* ]]; then
            # Replace dots with nothing
            NEWNAME="${BASENAME//./}"
            NEWPATH="$DIR/$NEWNAME"

            # Avoid overwriting existing folders
            if [[ -e "$NEWPATH" ]]; then
                echo "Skipping: Target folder '$NEWPATH' already exists."
            else
                echo "Renaming: '$FOLDER' -> '$NEWPATH'"
                mv "$FOLDER" "$NEWPATH"
            fi
        fi
    fi
done

echo "Operation complete."
