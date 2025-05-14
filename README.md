Filo-Science
============

Fish Logger for Science : application for recording the measurements of fish caught during scientific sampling campaigns

Realization: Eric Quinton for INRAE Nouvelle-Aquitaine - Cestas (France)

Copyright © INRAE 2019-2025 - Distributed under AGPL License

This software is desposited at Agence pour la Protection des Programmes, with the number IDDN.FR.001.360004.S.C.2019.000.31500.

## Installation
- deploy a linux server (debian or ubuntu)
- download the script [https://github.com/inrae/filo-science/raw/main/install/deploy_new_instance.sh](https://github.com/inrae/filo-science/raw/main/install/deploy_new_instance.sh) and execute it:
~~~
    sudo -s
    wget https://github.com/inrae/filo-science/raw/main/install/deploy_new_instance.sh
    ./deploy_new_instance.sh
~~~

The script will install all necessary components, create the database and deploy the software.

You must adapt the file /etc/apache2/sites-available/filo-science.conf to configure the dns used in your instance.


## Upgrade

Before each upgrade, verify if you have a recent backup of your database!

From version 25.0.0 or later: 

~~~
/var/www/filo2App/filo-science/upgrade.sh
~~~

