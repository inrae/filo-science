Filo-Science
============

Fish Logger for Science : application for recording the measurements of fish caught during scientific sampling campaigns

Realisation: Eric Quinton for INRAE Nouvelle-Aquitaine - Cestas (France)

Copyright © INRAE 2019-2020 - Distributed under AGPL License

This software is desposited at Agence pour la Protection des Programmes, with the number IDDN.FR.001.360004.S.C.2019.000.31500.

## Installation
- deploy a linux server (debian or ubuntu)
- download the script [https://github.com/inrae/filo-science/raw/master/install/deploy_new_instance.sh](https://github.com/inrae/filo-science/raw/master/install/deploy_new_instance.sh) and execute it:
~~~
    sudo -s
    wget https://github.com/inrae/filo-science/raw/master/install/deploy_new_instance.sh
    ./deploy_new_instance.sh
~~~

The script will install all necessary components, create the database and deploy the software.

You must adapt the file /etc/apache2/sites-available/filo-science.conf to configure the dns used in your instance.

You can deploy the software in a Docker Container too. See [https://github.com/inrae/filo-docker](https://github.com/inrae/filo-docker)

## Upgrade
- Choose the adapted version of the script into the folder: [https://github.com/inrae/filo-science/tree/master/install](https://github.com/inrae/filo-science/tree/master/install), for example *upgrade-1.6.0-1.7.0.sh* to upgrade from version 1.6.0 to 1.7.0.
- Download it and execute it:

~~~
    sudo -s
    wget https://github.com/inrae/filo-science/raw/master/install/upgrade-1.6.0-1.7.0.sh
    ./upgrade-1.6.0-1.7.0.sh
~~~
The script will download the release, upgrade the database if necessary and reconfigure the server.

Before upgrade, make sure you have a backup!
