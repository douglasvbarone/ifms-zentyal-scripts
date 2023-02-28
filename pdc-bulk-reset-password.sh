#!/bin/bash

file=$1

DEFAULT_PASSWORD=123456789
PASSWORD=${2:-$DEFAULT_PASSWORD}

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
  echo "---"
  USERNAME=$(echo $p | cut -d ";" -f 1)

  # Check if $USERNAME is empty
  if [ -z "$USERNAME" ]; then
    echo "Username is empty"
    continue
  fi

  # Check if user exists
  if ! samba-tool user show $USERNAME >/dev/null 2>&1; then
    echo "User $USERNAME do not exists"
    continue
  fi

  ./pdc-reset-password.sh $USERNAME $PASSWORD

done <$file
