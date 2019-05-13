#!/bin/bash
# install a new instance into a server
# must be executed with login root
# creation : Eric Quinton - 2018-08-17
# tested with debian 9.5
# php7.0 : if new version, change in the first lines of the script
VERSION=filo-science-1.0
downloadPath="https://github.com/Irstea/filo-science/archive/master.zip"
phpinifile="/etc/php/7.0/apache2/php.ini"

echo "this script will install apache server and php, postgresql and deploy the current version of filo-science"
read -p "Do you want to continue [y/n]?" response
if [ "$response" = "y" ] 
then
# installing packages
apt install unzip apache2 libapache2-mod-php7.0 php7.0 php7.0-ldap php7.0-pgsql php7.0-mbstring php7.0-xml php7.0-zip php7.0-imagick php7.0-gd php7.0-ldap fop postgresql postgresql-client postgresql-9.6-postgis-2.3
a2enmod ssl
a2enmod headers
a2enmod rewrite
# chmod -R g+r /etc/ssl/private
# usermod www-data -a -G ssl-cert
a2ensite default-ssl
a2ensite 000-default

# creation of directory
cd /var/www/html
mkdir filo-science
cd filo-science

# download software
echo "download software"
wget $downloadPath
unzip filo-science-master.zip
mv filo-science-master $VERSION
ln -s $VERSION filo-science

# update rights on files
chmod -R 755 .

# create param.inc.php file
mv filo-science/param/param.inc.php.dist filo-science/param/param.inc.php
# creation of database
echo "creation of the database"
cd filo-science/install
su postgres -c "psql -f init_by_psql.sql"
cd ../..
echo "you may verify the configuration of access to postgresql"
echo "look at /etc/postgresql/10/main/pg_hba.conf (verify your version). Only theses lines must be activate:"
echo '# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5'

read -p "Enter to continue" answer

# install backup program
echo "backup configuration - dump at 20:00 into /var/lib/postgresql/backup"
echo "please, set up a data transfert mechanism to deport them to another medium"
cp filo-science/install/pgsql/backup.sh /var/lib/postgresql/
chown postgres /var/lib/postgresql/backup.sh
line="0 20 * * * /var/lib/postgresql/backup.sh"
#(crontab -u postgres -l; echo "$line" ) | crontab -u postgres -
echo "$line" | crontab -u postgres -

# update rights to specific software folders
chmod -R 750 .
mkdir filo-science/display/templates_c
mkdir filo-science/temp
chgrp -R www-data .
chmod -R 770 filo-science/display/templates_c
chmod -R 770 filo-science/temp

# generate rsa key for encrypted tokens
echo "generate encryption keys for identification tokens"
openssl genpkey -algorithm rsa -out filo-science/param/id_filo-science -pkeyopt rsa_keygen_bits:2048
openssl rsa -in filo-science/param/id_filo-science -pubout -out filo-science/param/id_filo-science.pub
chown www-data filo-science/param/id_filo-science

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

# creation of virtual host
echo "creation of virtual site"
cp filo-science/install/apache2/filo-science.conf /etc/apache2/sites-available/
a2ensite filo-science
echo "you must modify the file /etc/apache2/sites-available/filo-science.conf"
echo "address of your instance, ssl parameters),"
echo "then run this command:"
echo "service apache2 reload"
read -p "Enter to terminate" answer

fi
# end of script
