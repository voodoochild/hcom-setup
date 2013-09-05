#!/bin/bash

DIRS=(${APP_PATH}/CustomerCare/HermesWebApp/Main ${APP_PATH}/Assets/CommonAssetPack/Main ${APP_PATH}/PropertyDetails/PropertyDetailsApp/Main ${APP_PATH}/PropertyDetails/PropertyDetailsApp/Main ${APP_PATH}/Shopping/ShoppingApp/Main  ${APP_PATH}/Landing/LandingApp/Main ${APP_PATH}/Booking/BookingApp/Main ${APP_PATH}/AdminTool/HcomAdminTool/Main)

for f in ${DIRS[@]}; do
    if [ $f = ${APP_PATH}/CustomerCare/HermesWebApp/Main ]; then
        if [ -d $f ]; then
            cp ${ENV_PATH}/install/build-art.properties $f/build.properties
            echo "copied build.properties to: $f"
        fi
    else
        if [ $f = ${APP_PATH}/AdminTool/HcomAdminTool/Main ]; then
            if [ -d $f ]; then
                cp ${ENV_PATH}/install/build-hat.properties $f/build.properties
                echo "copied build.properties to: $f"
            fi
        else
            if [ -d $f ]; then
                cp ${ENV_PATH}/install/build.properties $f/.
                echo "copied build.properties to: $f"
            fi
        fi
    fi
done
