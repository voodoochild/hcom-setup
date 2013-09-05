DIRS=(${ENV_PATH}/Tomcat/apps/CAP ${ENV_PATH}/Tomcat/apps/HWA ${ENV_PATH}/Tomcat/apps/SHA ${ENV_PATH}/Tomcat/apps/LPS ${ENV_PATH}/Tomcat/apps/BA ${ENV_PATH}/Tomcat/apps/PDA ${ENV_PATH}/Tomcat/apps/HAT)

for f in ${DIRS[@]}; do
    if [ $f = ${ENV_PATH}/Tomcat/apps/HAT ]; then
        if [ -d $f ]; then
            if [ ! -d $f/webapps ]; then
                mkdir $f/webapps
            fi
            if [ ! -d $f/logs ]; then
                mkdir $f/logs
            fi
            if [ ! -d $f/mvt_config ]; then
                mkdir -p $f/mvt_config/staging
                mkdir -p $f/mvt_config/backup
            fi
        fi
    else
        if [ -d $f ]; then
            if [ ! -d $f/webapps ]; then
                mkdir $f/webapps
            fi
            if [ ! -d $f/logs ]; then
                mkdir $f/logs
            fi
        fi
    fi
done
