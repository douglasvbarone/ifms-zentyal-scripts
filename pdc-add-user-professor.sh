#!/bin/bash

###############################
# Script to add a student     #
# Must be run as root         #
# For use with Zential Server #
###############################

USERNAME=$1
NAME=$2
DEFAULT_QUOTA=256000 # 256MB

# Check if arguments are not empty
if [ -z "$USERNAME" ] || [ -z "$NAME" ]; then
  echo "Usage: $0 <username> <name>"
  exit 1
fi

# Check if $USERNAME has spaces
if [[ $USERNAME =~ " " ]]; then
  echo "Username cannot have spaces"
  exit 1
fi

NAME=$(echo $NAME | tr "[A-Z]" "[a-z]" | sed -e "s/\b\(.\)/\u\1/g")

# Check if $USERNAME is already in use
if samba-tool user show $USERNAME >/dev/null 2>&1; then
  echo "User $USERNAME already exists"
  exit 1
fi

# Capitalize every first letter of $NAME

# Create user
echo "Creating user $USERNAME with name $NAME and password $USERNAME"
samba-tool user create $USERNAME $USERNAME --userou='OU=Professores,OU=IFMS-PP' --given-name="$NAME" --home-drive='H:' --home-directory="\\\\acadsrv.ACAD.PP.IFMS.EDU.BR\\$USERNAME" --use-username-as-cn --must-change-at-next-login

# Add user to group alunos
echo "Adding user $USERNAME to group professores"
samba-tool group addmembers professores $USERNAME

# Create home directory
echo "Creating home directory for user $USERNAME"
mkdir /home/$USERNAME
echo "Setting permissions for home directory"
chmod 700 /home/$USERNAME/ -R
chown $USERNAME:'domain users' /home/$USERNAME/ -R

# Set user quota
./pdc-setquota.sh $USERNAME $DEFAULT_QUOTA

echo "User $USERNAME ($NAME) created. Password must be changed at next login."
