#!/bin/bash

# load variables from configuration file
. conf/vars.env

if [ -n "$1" ]; then
    DJANGO_PORT="$1"
fi

# load functions from function library file
. lib/functions

### Main script ###

my_id=$(id -u)

test $my_id -eq 0
handle_error $? "Please run this script as root."

echo "Deploying to $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME"

# copy the application to the destination directory
rsync -a ./$DJANGO_PROJ_NAME $DJANGO_HOMEDIR/

# make sure all the content belongs do DJANGO_USERNAME
chown -R $DJANGO_USERNAME:$DJANGO_USERNAME $DJANGO_HOMEDIR

echo "Deployment finished"

# print user friendly output
print_output_deploy
