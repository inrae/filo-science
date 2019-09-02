#!/bin/bash
# upgrade an instance 2.2.2 to 2.2.3
OLDVERSION=filo-1.1
VERSION=filo-1.2.0
SQLSCRIPT=upgradedb-1.1-1.2.sql
echo "This script will install the release $VERSION"
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Filo-Science is $OLDVERSION ?"
echo "Is your actual version is in the folder /var/www/filo-science/$OLDVERSION, and the symbolic link filo point to $OLDVERSION?" 
read -p "Do you want to continue [Y/n]?" answer
if [[ $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then
cd /var/www/html/filo-science
rm -f *zip
# download last code
echo "download software"
wget https://github.com/Irstea/filo-science/archive/master.zip
read -p "Ok to install this release [Y/n]?" answer

if [[  $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then

unzip master.zip
mv filo-science-master/ $VERSION

# copy of last param into the new code
cp filo-science/param/param.inc.php $VERSION/param/
chgrp www-data $VERSION/param/param.inc.php

# keys for tokens
if [ -e filo-science/param/id_filo-science ]
then
cp filo-science/param/id_filo-science* $VERSION/param/
chown www-data $VERSION/param/id_filo-science
fi

#replacement of symbolic link
rm -f filo-science
ln -s $VERSION filo-science

# upgrade database
echo "update database"
chmod 755 /var/www/html/filo-science
cd filo-science/install
su postgres -c "psql -f $SQLSCRIPT"
cd ../..
chmod 750 /var/www/html/filo-science

# assign rights to new folder
find filo-science/ -type d -exec chmod -R 750 {} \;
find filo-science/ -type f -exec chmod -R 640 {} \;
mkdir filo-science/display/templates_c
mkdir filo-science/temp
chgrp -R www-data filo-science/
chmod -R 770 filo-science/display/templates_c
chmod -R 770 filo-science/temp


echo "Upgrade completed. Check, in the messages, if unexpected behavior occurred during the process" 
fi
fi
