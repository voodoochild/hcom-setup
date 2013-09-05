#!/bin/bash

# TODO: throw an error is $ENV_PATH isn't defined

ESC_ENV_PATH=`sed -e 's;/;\\\/;g' <<< "${ENV_PATH}"`

############################################################################
#   Update httpd.conf
############################################################################
httpd=/etc/apache2/httpd.conf
if [ -f $httpd ]; then
    echo -e "\nEditing Apache config:"
    username=`whoami`
    sudo perl -pi -e "s/#LoadModule ssl_module libexec\/apache2\/mod_ssl.so/LoadModule ssl_module libexec\/apache2\/mod_ssl.so/g" $httpd
    sudo perl -pi -e "s/#LoadModule proxy_module libexec\/apache2\/mod_proxy.so/LoadModule proxy_module libexec\/apache2\/mod_proxy.so/g" $httpd
    sudo perl -pi -e "s/#ServerName www.example.com:80/ServerName localhost:80/g" $httpd
    sudo perl -pi -e "s/Include ${ESC_ENV_PATH}\/conf\/apache\/hcom-vhost\*//g" $httpd
    echo "Adding to $httpd"
    echo "Include ${ENV_PATH}/conf/apache/hcom-vhost*" | sudo tee -a $httpd
    echo -e "\nStarting Apache…"
    sudo apachectl restart
else
    echo "Missing $httpd file!"
    exit 1
fi

############################################################################
#   Update hcom apache confs
############################################################################

# TODO: could this be refactored to use APP_PATH?

echo -e "\nEditing Hcom Apache configs:"
username=`whoami`
sudo perl -pi -e "s/Users\/(.+)\/hcom-dev/Users\/$username\/hcom-dev/g" ${ENV_PATH}/conf/apache/hcom-vhost-80.conf
sudo perl -pi -e "s/Users\/(.+)\/hcom-dev/Users\/$username\/hcom-dev/g" ${ENV_PATH}/conf/apache/hcom-vhost-443.conf

echo -e "\nStarting Apache…"
sudo apachectl restart

############################################################################
#
############################################################################

echo -e "\nSUCCESSFUL"
