#!/bin/bash
# upgrade an instance 2.2.2 to 2.2.3
OLDVERSION=filo-1.3.0
VERSION=filo-1.4.0
SQLSCRIPT=upgradedb-1.3-1.4.sql
PHPVER=7.3
echo "This script will install the release $VERSION"
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Filo-Science is $OLDVERSION ?"
echo "Is your actual version is in the folder /var/www/filo-science/$OLDVERSION, and the symbolic link filo point to $OLDVERSION?"
read -p "Do you want to continue [Y/n]?" answer
if [[ $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then
echo "This version run only with php7.2 or above"
echo "Your PHP version is :"
php -version
read -p "Do you want to upgrade the php version to 7.3 [Y/n]?" phpanswer
if [[$phpanswer = "y" || $phpanswer = "Y" || -z $phpanswer]];
read -p "What is your version of debian? (jessie strech buster)?" debianrelease
read -p "What is your old version of PHP (only the 2 firsts numbers, as 7.0?" phpoldversion
then
apt-get install ca-certificates apt-transport-https
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ $debianrelease main" | sudo tee /etc/apt/sources.list.d/php.list
apt-get update
apt-get install libapache2-mod-php$PHPVER php$PHPVER php$PHPVER-cli php$PHPVER-ldap php$PHPVER-pgsql php$PHPVER-mbstring php$PHPVER-xml php$PHPVER-zip php$PHPVER-imagick php$PHPVER-gd php$PHPVER-curl
a2dismod php$phpoldversion
a2enmod php$PHPVER
phpinifile="/etc/php/$PHPVER/apache2/php.ini"
# adjust php.ini values
upload_max_filesize="=100M"
post_max_size="=50M"
max_execution_time="=120"
max_input_time="=240"
memory_limit="=1024M"
for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
do
 sed -i "s/^\($key\).*/\1 $(eval echo \${$key})/" $phpinifile
done
service apache2 restart
echo "end of upgrade of php"
fi

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

