#!/bin/bash

# Ensure both FILE_PATH and COMMIT_MSG are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <file_path> <commit_message>"
  exit 1
fi

FILE_PATH=$1
COMMIT_MSG=$2

if git diff --quiet "$FILE_PATH"; then
  # No changes
  echo "No changes in $FILE_PATH"
  exit 0
else
  # there are changes, let's stage and commit them
  git add "$FILE_PATH" || {
    echo "Failed to stage $FILE_PATH" >&2
    exit 1
  }

  git commit -m "$COMMIT_MSG" || {
    echo "Failed to commit changes in $FILE_PATH" >&2
    exit 1
  }

  echo "Changes in $FILE_PATH committed successfully with message: $COMMIT_MSG"
  exit 0
fi
