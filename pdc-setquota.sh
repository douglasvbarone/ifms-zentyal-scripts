#!/bin/bash

# Check if is running as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

USERNAME=$1
QUOTA=$2

# Check if arguments are not empty
if [ -z "$USERNAME" ] || [ -z "$QUOTA" ]; then
  echo "Usage: $0 <username> <quota>"
  exit 1
fi

# Check if $USERNAME exists
if ! samba-tool user show $USERNAME >/dev/null 2>&1; then
  echo "User $USERNAME do not exists"
  exit 1
fi

# Set user quota
echo "Setting user quota for user $USERNAME"
uidNumber=$(id -u $USERNAME)
/usr/share/zentyal-samba/user-quota -s $uidNumber $QUOTA
