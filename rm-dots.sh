#!/bin/bash

# Get the target directory or use the current directory
DIR=${1:-.}

# Verify the directory exists
if [[ ! -d "$DIR" ]]; then
    echo "Error: The specified path is not a directory."
    exit 1
fi

# Collect folders with dots and simulate the renaming
declare -A FOLDERS_TO_RENAME

# Scan the directory for folders with dots in their names
echo "Scanning for folders with dots in their names in: $DIR"
for FOLDER in "$DIR"/*/; do
    # Strip the trailing slash
    FOLDER=${FOLDER%/}

    # Check if it's a directory
    if [[ -d "$FOLDER" ]]; then
        BASENAME=$(basename "$FOLDER")
        
        # Check if the folder name contains dots
        if [[ "$BASENAME" == *.* ]]; then
            # Replace dots with spaces
            NEWNAME="${BASENAME//./ }"
            FOLDERS_TO_RENAME["$FOLDER"]="$NEWNAME"
        fi
    fi
done

# If no folders to rename, exit early
if [[ ${#FOLDERS_TO_RENAME[@]} -eq 0 ]]; then
    echo "No folders with dots found in the directory: $DIR"
    exit 0
fi

# Preview the changes
echo "Preview of folders to be renamed:"
for FOLDER in "${!FOLDERS_TO_RENAME[@]}"; do
    NEWNAME="${FOLDERS_TO_RENAME["$FOLDER"]}"
    echo "  Folder: $FOLDER -> New Name: $DIR/$NEWNAME"
done

# Ask for confirmation before proceeding
read -p "Do you want to proceed with renaming? [y/n]: " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Perform the renaming
COUNT=0
for FOLDER in "${!FOLDERS_TO_RENAME[@]}"; do
    NEWNAME="${FOLDERS_TO_RENAME["$FOLDER"]}"
    
    # Avoid overwriting existing folders
    if [[ -e "$DIR/$NEWNAME" ]]; then
        echo "Skipping: Target folder '$DIR/$NEWNAME' already exists."
    else
        echo "Renaming: '$FOLDER' -> '$DIR/$NEWNAME'"
        mv "$FOLDER" "$DIR/$NEWNAME"
        ((COUNT++))
    fi
done

# Summary
echo "Operation completed. Renamed $COUNT folders."
