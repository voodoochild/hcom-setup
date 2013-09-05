# !/bin/bash

hostfile=/etc/hosts
echo "Updating hosts file ${hostfile}…"

sudo perl -pi -e "s/^.*(hotels|hoteles|womblelabs|hotell|hoteis).*$//g" $hostfile
sudo perl -i -ne 's/^$//g || print' $hostfile
cat ${ENV_PATH}/install/hosts | sudo tee -a $hostfile > /dev/null
