#!/bin/bash

E_OK=0
E_ERR=1

DJANGO_PACKAGES="python3-django python3-djangorestframework python3-psycopg2 gunicorn postgresql-client vim makepasswd rsync"

# load variables from configuration file
. conf/vars.env

# load functions from function library file
. lib/functions

### Main script ###

my_id=$(id -u)

test $my_id -eq 0
handle_error $? "Please run this script as root."

DJANGO_SUPERUSER_PASSWORD=$(makepasswd)

echo "Creating user $DJANGO_USERNAME for Django execution"
echo

# checking if user exists
getent passwd |grep -w "^django"
let result=1-$?
handle_error $result "User $DJANGO_USERNAME already exists. This app might have been installed already."

# adding the user (this would no fail if the user exists, therefore the pre-check)
adduser --system --home=$DJANGO_HOMEDIR --disabled-password --group --shell=/bin/bash $DJANGO_USERNAME
handle_error $? "Error adding user $DJANGO_USERNAME"

echo "Installing Django related packages"
apt-get update &> /dev/null
apt-get install -y -q=2 $DJANGO_PACKAGES &> /dev/null
handle_error $? "Error installing packages"

# copy the application to the destination directory
cp -R $DJANGO_PROJ_NAME $DJANGO_HOMEDIR/

# make sure all the content belongs do DJANGO_USERNAME
chown -R $DJANGO_USERNAME:$DJANGO_USERNAME $DJANGO_HOMEDIR

# create the tables for the default installed apps on the database
echo
sudo su - $DJANGO_USERNAME -c "cd $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME; python3 manage.py migrate"
handle_error $? "Error migrating database tables"

# creating superuser
echo
sudo su - $DJANGO_USERNAME -c "cd $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME; DJANGO_SUPERUSER_PASSWORD=$DJANGO_SUPERUSER_PASSWORD python3 manage.py createsuperuser --no-input --username $DJANGO_SUPERUSER_USERNAME --email $DJANGO_SUPERUSER_EMAIL"
handle_error $? "Error migrating superuser $DJANGO_SUPERUSER_USERNAME"

echo "  * username is $DJANGO_SUPERUSER_USERNAME"
echo "  * password is $DJANGO_SUPERUSER_PASSWORD"

# print user friendly output
print_output
