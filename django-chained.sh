#!/bin/bash

E_OK=0
E_ERR=1

DJANGO_PACKAGES="python3-django python3-djangorestframework python3-psycopg2 gunicorn postgresql-client vim makepasswd rsync"

SRC_DIR=./src

# load variables from configuration file
. conf/vars.env

# load functions from function library file
. lib/functions

### Main script ###

my_id=$(id -u)

test $my_id -eq 0
handle_error $? "Please run this script as root."

DJANGO_SUPERUSER_PASSWORD=$(makepasswd)

# checking if user exists
getent passwd |grep -w "^$DJANGO_USERNAME" &> /dev/null
let result=1-$?
handle_error $result "User $DJANGO_USERNAME already exists. This app might have been installed already."

echo "Creating user $DJANGO_USERNAME for Django execution"
echo
adduser --system --home=$DJANGO_HOMEDIR --disabled-password --group --shell=/bin/bash $DJANGO_USERNAME
handle_error $? "Error adding user $DJANGO_USERNAME"

echo "Installing Django related packages"
apt-get update &> /dev/null
apt-get install -y -q=2 $DJANGO_PACKAGES &> /dev/null
handle_error $? "Error installing packages"

echo
echo "Creating project $DJANGO_PROJ_NAME"
sudo su - $DJANGO_USERNAME -c "django-admin startproject $DJANGO_PROJ_NAME"
handle_error $? "Error creating project $DJANGO_PROJ_NAME"

echo "Creating app $DJANGO_APP_NAME inside project $DJANGO_PROJ_NAME"
sudo su - $DJANGO_USERNAME -c "cd $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME; python3 manage.py startapp $DJANGO_APP_NAME"
handle_error $? "Error creating app $DJANGO_APP_NAME inside project $DJANGO_PROJ_NAME"

echo "Creating project structure"

# copying application custom files
for src_file in urls.py views.py; do
  cp -f $SRC_DIR/app/$src_file $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/$DJANGO_APP_NAME/
done

# copying project custom files
for src_file in urls.py settings.py custom_processor.py; do
  cp -f $SRC_DIR/proj/$src_file $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/$DJANGO_PROJ_NAME
done

mkdir -p $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/templates/registration

# copying the HTML templates
for src_file in base.html toplevel.html index.html registration/login.html; do
  cp -f $SRC_DIR/proj/templates/$src_file $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/templates/$src_file
done

for static_dir in img css js; do
  mkdir -p $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/static/$static_dir
done

# Prettify, if desired
if [ $PRETTIFY = "yes" ]; then
  cp -f $SRC_DIR/proj/templates/base.pretty.html $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/templates/base.html
  cp -f $SRC_DIR/proj/static/css/pico.min.css $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/static/css/
fi

# replace app name, app display name and project name
sed -i "s/DJANGO_APP_NAME/$DJANGO_APP_NAME/g" $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/$DJANGO_PROJ_NAME/settings.py
sed -i "s/DJANGO_APP_DISPLAY_NAME/$DJANGO_APP_DISPLAY_NAME/g" $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/$DJANGO_PROJ_NAME/settings.py
sed -i "s/DJANGO_PROJ_NAME/$DJANGO_PROJ_NAME/g" $DJANGO_HOMEDIR/$DJANGO_PROJ_NAME/$DJANGO_PROJ_NAME/settings.py

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
