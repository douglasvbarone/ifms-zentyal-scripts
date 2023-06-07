#!/bin/bash

# Check if is running as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

USERNAME=$1

# Check if arguments are not empty
if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Check if $USERNAME starts with a number
if [[ $USERNAME =~ ^[0-9] ]]; then
  echo "Username cannot start with a number. Appending 'u' to the beginning of the username..."
  USERNAME="u$USERNAME"
fi

# Check if user exists
if ! samba-tool user show $USERNAME >/dev/null 2>&1; then
  echo "User $USERNAME does not exist"
  exit 1
fi

samba-tool user delete $USERNAME

rm -rf /home/$USERNAME
echo "/home/$USERNAME directory deleted"
