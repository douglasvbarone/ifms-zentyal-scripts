#!/bin/bash

# Check if is running as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

USERNAME=$1
DEFAULT_PASSWORD=123456789
PASSWORD=${2:-$DEFAULT_PASSWORD}

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

# Check if $USERNAME exists
if ! samba-tool user show $USERNAME >/dev/null 2>&1; then
  echo "User $USERNAME do not exists"
  exit 1
fi

# Set user password
echo "Setting user password $PASSWORD for user $USERNAME"

# Set user password with smbpasswd, inject password and password confirmation into stdin
echo -e "$PASSWORD\n$PASSWORD" | smbpasswd -s -a $USERNAME >>/var/log/samba/smbpasswd.log 2>&1

# Force password change on next login
echo "Forcing password change on next login for user $USERNAME"
net sam set pwdmustchangenow $USERNAME yes >>/var/log/samba/smbpasswd.log 2>&1
