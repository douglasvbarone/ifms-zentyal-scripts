#!/bin/bash

USERNAME=$1

# Check if arguments are not empty
if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Check if user exists
if ! samba-tool user show $USERNAME >/dev/null 2>&1; then
  echo "User $USERNAME does not exist"
  exit 1
fi

samba-tool user delete $USERNAME

rm -rf /home/$USERNAME
echo "/home/$USERNAME directory deleted"
