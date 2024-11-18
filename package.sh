#!/bin/bash

#!/bin/bash

# load variables from configuration file
. conf/vars.env

# load functions from function library file
. lib/functions

app_pkg_file=/tmp/$DJANGO_PROJ_NAME.tar.gz
app_dist_dir=/tmp/$DJANGO_PROJ_NAME

my_id=$(id -u)

test $my_id -eq 0
handle_error $? "Please run this script as root."

if [ -f $app_pkg_file ]; then
    echo "Error: package file $app_pkg_file already exists"
    exit $E_ERR
fi

mkdir -p $app_dist_dir

rsync -a --delete --exclude="*__pycache__*" --exclude="*db.sqlite3*" $DJANGO_HOMEDIR/ $app_dist_dir
handle_error $? "Error preparing $app_dist_dir"

chown -R root:root $app_dist_dir

cp -f src/pkg/install.sh $app_dist_dir/
cp -f src/pkg/deploy.sh $app_dist_dir/

mkdir -p $app_dist_dir/conf
cp -f src/pkg/vars.env $app_dist_dir/conf/

echo "DJANGO_PROJ_NAME=$DJANGO_PROJ_NAME" >> $app_dist_dir/conf/vars.env
echo "DJANGO_APP_NAME=$DJANGO_APP_NAME" >> $app_dist_dir/conf/vars.env

mkdir -p $app_dist_dir/lib
cp -f src/pkg/functions $app_dist_dir/lib

tar -C /tmp -zcf $app_pkg_file $DJANGO_PROJ_NAME &> /dev/null
handle_error $? "Error packing $app_pkg_file"

echo "Your Django app distribution file is available at $app_pkg_file"
echo
echo "md5sum for this file:"
md5sum $app_pkg_file
echo

rm -rf $app_dist_dir

# if there were no erros so far then we are ok
exit $E_OK


