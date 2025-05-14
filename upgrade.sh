#!/bin/bash
cd /var/www/filo2App/filo-science
git restore .
git pull origin main
./upgradedb.sh
systemctl restart apache2
