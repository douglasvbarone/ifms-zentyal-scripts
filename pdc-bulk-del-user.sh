#!/bin/bash

file=$1

# Check if arguments are not empty
if [ -z "$file" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

# Check if file exists
if [ ! -f "$file" ]; then
  echo "File $file does not exist"
  exit 1
fi

# Check if file is empty
if [ ! -s "$file" ]; then
  echo "File $file is empty"
  exit 1
fi

while IFS="" read -r p || [ -n "$p" ]; do
  USERNAME=$(echo $p | cut -d ";" -f 1)
  NAME=$(echo $p | cut -d ";" -f 2)

  # Check if $USERNAME is empty
  if [ -z "$USERNAME" ]; then
    echo "Username is empty"
    continue
  fi

  echo "---"
  ./pdc-del-user.sh $USERNAME

done <$file
