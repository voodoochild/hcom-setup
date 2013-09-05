#!/bin/bash

# TODO: replace all `type -t` invocations so that zsh works

####################################################
# Change dev for stable etc
# after any changes run hcom_linkwar
# Any new shells will default to 'dev' regardless
#     of the war symlinks
#     i.e. may need to run hcom_linkwar if
#     it's not working :)
####################################################

path_to_cap=`eval echo ${APP_PATH}/Assets/CommonAssetPack/Main`
path_to_hwa=`eval echo ${APP_PATH}/CustomerCare/HermesWebApp/Main`
path_to_sha=`eval echo ${APP_PATH}/Shopping/ShoppingApp/Main`
path_to_lps=`eval echo ${APP_PATH}/Landing/LandingApp/Main`
path_to_pda=`eval echo ${APP_PATH}/PropertyDetails/PropertyDetailsApp/Main`
path_to_mvt=`eval echo ${APP_PATH}/MVT/MvtConfigurationPack/Main`
path_to_hat=`eval echo ${APP_PATH}/AdminTool/HcomAdminTool/Main`
path_to_ba=`eval echo ${APP_PATH}/Booking/BookingApp/Main`

####################################################
# Don't change below
####################################################

export JAVA6_HOME=${ENV_PATH}/Java/JavaVirtualMachines/1.6.0_26-b03-383.jdk/Contents/Home
export JAVA7_HOME=${ENV_PATH}/Java/JavaVirtualMachines/1.7.0_25.jdk/Contents/Home
export JAVA_HOME=$JAVA7_HOME
export ANT_HOME=${ENV_PATH}/Ant/apache-ant-1.8.2
export CATALINA_HOME=${ENV_PATH}/Tomcat/Home
export CONTENT_BASE=${ENV_PATH}/content
export PATH=$PATH:${JAVA_HOME}
export PATH=$PATH:${CATALINA_HOME}
export PATH=$PATH:${JAVA_HOME}/bin:${ANT_HOME}/bin
export ANT_OPTS="-Xmx512M -Xms512M -XX:-UseGCOverheadLimit -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=320m"

####################################################
# Tomcat Ports
####################################################

export HCOM_APP_PORT_CAP=9090
export HCOM_APP_PORT_CAP_SSL=9191
export HCOM_APP_PORT_HWA=14080
export HCOM_APP_PORT_HWA_SSL=14081
export HCOM_APP_PORT_LPS=14082
export HCOM_APP_PORT_SHA=14083
export HCOM_APP_PORT_PDA=14084
export HCOM_APP_PORT_BA=14085
export HCOM_APP_PORT_HAT=14090

####################################################
#
####################################################

APPS=(cap hwa lps sha pda hat)
LOG_DIRS=(${ENV_PATH}/Tomcat/apps/HWA/logs ${ENV_PATH}/Tomcat/apps/LPS/logs ${ENV_PATH}/Tomcat/apps/PDA/logs ${ENV_PATH}/Tomcat/apps/SHA/logs ${ENV_PATH}/Tomcat/apps/CAP/logs ${ENV_PATH}/Tomcat/apps/HAT/logs ${ENV_PATH}/Tomcat/apps/BA/logs ${ENV_PATH}/Tomcat/Home/logs)

boldtext=`tput bold`
normaltext=`tput sgr0`

alias hcom-dev="cd ${APP_PATH}"
alias hcom-env="cd ${ENV_PATH}"

hcom_linkwar(){
    hwa_war=$path_to_hwa/tmp/dist/bin/hermes_web_app.war
    lps_war=$path_to_lps/tmp/dist/bin/landing_app.war
    sha_war=$path_to_sha/shoppingapp-web/target/war/shopping_app.war
    pda_war=$path_to_pda/propertydetailsapp-web/target/war/property_details_app.war
    cap_war=$path_to_cap/tmp/dist/bin/common_asset_pack.war
    hat_war=$path_to_hat/tmp/dist/bin/hcom_admin_tool.war

    if [ ! -f $hwa_war ]; then
        sudo rm ${ENV_PATH}/Tomcat/apps/HWA/webapps/ROOT
        sudo ln -s $hwa_war ${ENV_PATH}/Tomcat/apps/HWA/webapps/ROOT
        echo 'Linked HermesWebApp'
    else
        echo 'No built HermesWebApp to link'
    fi
    if [ ! -f $lps_war ]; then
        sudo rm ${ENV_PATH}/Tomcat/apps/LPS/webapps/ROOT
        sudo ln -s $lps_war ${ENV_PATH}/Tomcat/apps/LPS/webapps/ROOT
        echo 'Linked LandingApp'
    else
        echo 'No built LandingApp to link'
    fi
    if [ ! -f $sha_war ]; then
        sudo rm ${ENV_PATH}/Tomcat/apps/SHA/webapps/ROOT
        sudo ln -s $sha_war ${ENV_PATH}/Tomcat/apps/SHA/webapps/ROOT
        echo 'Linked ShoppingApp'
    else
        echo 'No built ShoppingApp to link'
    fi
    if [ ! -f $pda_war ]; then
        sudo rm ${ENV_PATH}/Tomcat/apps/PDA/webapps/ROOT
        sudo ln -s $pda_war ${ENV_PATH}/Tomcat/apps/PDA/webapps/ROOT
        echo 'Linked PropertyDetailsApp'
    else
        echo 'No built PropertyDetailsApp to link'
    fi
    if [ ! -f $cap_war ]; then
        sudo rm ${ENV_PATH}/Tomcat/apps/CAP/webapps/ROOT
        sudo ln -s $cap_war ${ENV_PATH}/Tomcat/apps/CAP/webapps/ROOT
        echo 'Linked CAP'
    else
        echo 'No built CAP to link'
    fi
    if [ ! -f $hat_war ]; then
        sudo rm ${ENV_PATH}/Tomcat/apps/HAT/webapps/ROOT
        sudo ln -s $hat_war ${ENV_PATH}/Tomcat/apps/HAT/webapps/ROOT
        echo 'Linked HAT'
    else
        echo 'No built HAT to link'
    fi
}


hcom_rm_logs(){
    for f in ${LOG_DIRS[@]}; do
        if [ -d $f ]; then
            for file in $(find $f -type f \( -name "*.log" -o -name "*.out" \)) ; do
                echo "Clearing: ${file}"
                echo "$(date +%Y-%m-%d-%H:%M:%S) - Cleared with hcom_rm_logs" > ${file}
            done
        fi
    done
}


hcom_app(){
    if [ $# = "0" ]
    then
        echo 'Usage:'
        echo "${boldtext}hcom_app \$APPNAME [start/stop]${normaltext}"
        echo ''
        echo 'Examples:'
        echo '- hcom_app hwa start'
        echo '- hcom_app cap stop'
    else
        app=${1}
        app=$( echo "$app" | tr -s  '[:lower:]'  '[:upper:]' )
        mode=${2}
        currentdir=`pwd`

        if [ "$app" = "HWA" ] || [ "$app" = "PDA" ] || [ "$app" = "SHA" ] || [ "$app" = "HAT" ]; then
            export JAVA_HOME=$JAVA7_HOME
        else
            export JAVA_HOME=$JAVA6_HOME
        fi

        if [ ! -d ${ENV_PATH}/Tomcat/apps/$app/ ]; then
            echo "'${1}' is not a valid app name"
        else
            # check if app is running
            running=`ps xu | grep apps/${app} | grep -v grep | awk '{ print $2 }'`

            cd ${ENV_PATH}/Tomcat/apps/$app/
            if [ "$mode" = '' ]; then
                mode="start"
            fi
            if [ "${mode}" = "start" ]; then
                if [ "$running" = "" ]; then
                    # check for ROOT.xml
                    rootxml=conf/Catalina/dev-hotels.com/ROOT.xml
                    echo "Locating ROOT.xml"
                    if [ ! -f ${rootxml} ]; then
                        echo "Missing - restoring ${rootxml}"
                        cp ${rootxml}.bak ${rootxml}
                    fi
                    # backup ROOT.xml
                    cp ${rootxml} ${rootxml}.bak

                    # check if cap is running
                    if [ "$app" != "CAP" ] && [ "$app" != "HAT" ]; then
                        echo "Checking for CAP…"
                        running=`ps xu | grep apps/CAP | grep -v grep | awk '{ print $2 }'`
                        if [ "$running" = "" ]; then
                            echo "CAP needs to be running…"
                            thenstart=$app
                            hcom_app cap
                            hcom_app $thenstart
                        else
                            echo "CAP running"
                            echo "Starting ${app}…"
                            sleep 2
                            bin/startup
                        fi
                    else
                        # CAP
                        echo "Starting ${app}…"
                        bin/startup
                    fi
                else
                    echo "$app is already running"
                    echo "- 'hcom_app ${1} stop' to shutdown"
                    echo "- 'hcom_app_kill ${1}' to force kill if needed"
                fi
            else
                if [ "$running" = "" ]; then
                    echo "$app is not running"
                else
                    echo "Shutting down ${app}…"
                    bin/shutdown
                    killcount=1
                    while [ "`ps -ef | grep catalina | grep Tomcat/apps/$app`" != "" ]
                    do
                        killcount=$(( $killcount + 1 ))
                        if [ "$killcount" = "20" ]; then
                            echo "."
                            hcom_app_kill $1
                        else
                            echo -ne "."
                            sleep 0.5
                        fi
                    done
                    echo -e "\n${app} stopped"
                fi
            fi
            cd $currentdir
        fi
    fi
}


hcom_app_restart(){
    hcom_app ${1} stop && hcom_app ${1} start
}


hcom_app_startwithlog(){
    hcom_app ${1} && hcom_log ${1}
}


hcom_app_all(){
    # for some ridiculous reason we have to have
    # MvtConfigurationPack locally
    # ensure it's up to date
    hcom_get_revision mvt

    for app in ${APPS[@]}; do
        if [  -d ${ENV_PATH}/Tomcat/apps/$app/ ]; then
            hcom_app $app stop
            hcom_get_revision $app stop
        fi
    done
    for app in ${APPS[@]}; do
        if [  -d ${ENV_PATH}/Tomcat/apps/$app/ ]; then
            hcom_build $app
            hcom_app $app start
        fi
    done
}


hcom_app_kill(){
    app=$1
    app=$( echo "$app" | tr -s  '[:lower:]'  '[:upper:]' )
    pid=`ps xu | grep apps/${app} | grep -v grep | awk '{ print $2 }'`
    if [ "$pid" = "" ]; then
        echo "${app} is not running"
    else
        echo $pid
        echo "Killing ${app} pid=${pid}…"
        kill -9 ${pid}
    fi
}


hcom_app_start_all(){
    for app in ${APPS[@]}; do
        if [  -d ${ENV_PATH}/Tomcat/apps/$app/ ]; then
            hcom_app $app start
        fi
    done
}


hcom_app_stop_all(){
    for app in ${APPS[@]}; do
        if [  -d ${ENV_PATH}/Tomcat/apps/$app/ ]; then
            hcom_app $app stop
        fi
    done
}


hcom_build(){
    if [ $# = "0" ]
    then
        echo 'Usage:'
        echo "${boldtext}hcom_build \$APPNAME${normaltext}"
        echo ''
        echo 'Examples:'
        echo '- hcom_build hwa'
    else
        app=${1}
        app=$( echo "$app" | tr -s  '[:lower:]'  '[:upper:]' )
        app_path='path-to-app'
        web_path='path-to-app-web-module'

        export JAVA_HOME=$JAVA6_HOME
        if [ "$app" = "HWA" ]; then
            export JAVA_HOME=$JAVA7_HOME
            app_path=$path_to_hwa
        fi
        if [ "$app" = "HAT" ]; then
            export JAVA_HOME=$JAVA7_HOME
            app_path=$path_to_hat
        fi
        if [ "${app}" = "LPS" ]; then
            app_path=$path_to_lps
        fi
        if [ "${app}" = "SHA" ]; then
            export JAVA_HOME=$JAVA7_HOME
            app_path=$path_to_sha
            web_path=$path/shoppingapp-web
        fi
        if [ "${app}" = "CAP" ]; then
            app_path=$path_to_cap
        fi
        if [ "${app}" = "PDA" ]; then
            export JAVA_HOME=$JAVA7_HOME
            app_path=$path_to_pda
            web_path=$path/propertydetailsapp-web
        fi
        if [ "$app" = "BA" ]; then
            export JAVA_HOME=$JAVA7_HOME
            app_path=$path_to_ba
        fi

        currentdir=`pwd`
        if [ ! -d $app_path ]; then
            echo "'${1}' is not a valid app name"
        else
            if [ "${2}" = 'update-ui' ]; then
                echo -e "Updating-UI ${app}…\n-------------------------------"
                if [ "${app}" = "SHA" ] || [ "$app" = "PDA" ]; then
                    pushd $web_path
                    mvn antrun:run
                    popd
                else
                    cd $app_path
                    ant ${2}
                fi
            else
                # check if app is running
                echo "Checking if $app is running…"
                running=`ps xu | grep apps/${app} | grep -v grep | awk '{ print $2 }'`
                if [ "$running" != "" ]; then
                    hcom_app ${app} stop
                fi
                echo "$app is stopped. Continuing with build"
                cd $app_path
                if [ "${2}" = '' ]; then
                    echo -e "Building ${app}…\n-------------------------------"
                    if [ "${app}" = "SHA" ] || [ "$app" = "PDA" ]; then
                        mvn clean install
                    else
                        ant build
                    fi
                else
                    echo -e "Building ${app} ${2}…\n-------------------------------"
                    if [ "${app}" = "SHA"] || [ "$app" = "PDA" ]; then
                        mvn ${2}
                    else
                        ant ${2}
                    fi
                fi
            fi
            cd $currentdir
        fi
    fi
}


hcom_updateui(){
    hcom_build $1 'update-ui'
}


hcom_log(){
    if [ $# = "0" ]
    then
        echo 'Usage:'
        echo "${boldtext}hcom_log \$APPNAME${normaltext}"
        echo ''
        echo 'Examples:'
        echo '- hcom_log hwa'
        echo '- hcom_log cap'
    else
        app=${1}
        app=$( echo "$app" | tr -s  '[:lower:]'  '[:upper:]' )

        if [ ! -d ${ENV_PATH}/Tomcat/apps/$app/ ]; then
            echo "'${1}' is not a valid app name"
        else
            if [ ! -f ${ENV_PATH}/Tomcat/apps/$app/logs/catalina.out ]; then
                echo "log file doesn't exist for $app"
            else
                tail -f ${ENV_PATH}/Tomcat/apps/$app/logs/catalina.out
            fi
        fi
    fi
}


hcom_lint(){
    if [ $# = "0" ]
    then
        echo 'Usage:'
        echo "${boldtext}hcom-lint \$APPNAME${normaltext}"
        echo ''
        echo 'Examples:'
        echo '- hcom_lint cap'
    else
        app=${1}
        app=$( echo "$app" | tr -s  '[:lower:]'  '[:upper:]' )
        app_path='path-to-app'

        export JAVA_HOME=$JAVA6_HOME
        if [ "${app}" = "HWA" ]; then
            export JAVA_HOME=$JAVA7_HOME
            app_path=$path_to_hwa
        fi
        if [ "${app}" = "LPS" ]; then
            app_path=$path_to_lps
        fi
        if [ "${app}" = "SHA" ]; then
            app_path=$path_to_sha
        fi
        if [ "${app}" = "CAP" ]; then
            app_path=$path_to_cap
        fi
        if [ "${app}" = "PDA" ]; then
            app_path=$path_to_pda
        fi
        if [ "${app}" = "HAT" ]; then
            app_path=$path_to_hat
        fi

        currentdir=`pwd`
        if [ ! -d $app_path ]; then
            echo "'${1}' is not a valid app name"
        else
            echo -e "Linting ${app}…\n-------------------------------"
            cd $app_path
            ant -f build-web.xml jslint
        fi
        cd $currentdir
    fi
}


hcom_get_revision(){
    if [ $# = "0" ]
    then
        echo 'Usage:'
        echo "${boldtext}hcom_get_revision \$APPNAME${normaltext} [force]"
        echo ''
        echo 'Examples:'
        echo '- hcom_get_revision hwa'
        echo '- hcom_get_revision la force'
    else
        app=${1}
        app=$( echo "$app" | tr -s  '[:lower:]'  '[:upper:]' )
        # only run if p4 client is installed
        if [ "`type -t p4`" = 'file' ]; then
            user=`whoami`
            app_path='path-to-app'
            if [ "${app}" = "HWA" ]; then
                app_path=$path_to_hwa
            fi
            if [ "${app}" = "LPS" ]; then
                app_path=$path_to_lps
            fi
            if [ "${app}" = "SHA" ]; then
                app_path=$path_to_sha
            fi
            if [ "${app}" = "CAP" ]; then
                app_path=$path_to_cap
            fi
            if [ "${app}" = "MVT" ]; then
                app_path=$path_to_mvt
            fi
            if [ "${app}" = "PDA" ]; then
                app_path=$path_to_pda
            fi
            if [ "${app}" = "HAT" ]; then
                app_path=$path_to_hat
            fi

            if [ ! -d $app_path ]; then
                echo "'${1}' is not a valid app name"
            else
                echo "Syncing ${app}…"
                if [ "${2}" = "force" ]; then
                    p4 sync -f $app_path/...#head
                else
                    p4 sync $app_path/...#head
                fi
            fi
        else
            echo "P4 command-line client is not installed"
            if [ "`type -t brew`" != 'file' ]; then
                read -p "Download client? (y/n)?"
                [ "$REPLY" == "y" ] && open 'http://www.perforce.com/perforce/downloads/choose/P4Macintosh.html'
            else
                read -p "Download client using homebrew? (y/n)?"
                [ "$REPLY" == "y" ] && brew install p4
            fi
        fi
    fi
}


hcom_help(){
    echo ""
    echo "${boldtext}hcom_app \$APPNAME [start/stop]${normaltext}"
    echo "  – Start/stop an app (e.g.hcom-app hwa start, hcom-app la stop)"
    echo "${boldtext}hcom_build \$APPNAME${normaltext}"
    echo "  – Build an app (e.g.hcom-build hwa [optional ant target])"
    echo "${boldtext}hcom_updateui \$APPNAME${normaltext}"
    echo "  – Call update-ui (e.g.hcom-update-ui hwa)"
    echo "${boldtext}hcom_lint \$APPNAME${normaltext}"
    echo "  – JSlint (e.g.hcom-lint cap)"
    echo "${boldtext}hcom_app_start_all${normaltext}"
    echo "  – Starts all built apps"
    echo "${boldtext}hcom_app_stop_all${normaltext}"
    echo "  – Stops all running apps"
    echo "${boldtext}hcom_log \$APPNAME${normaltext}"
    echo "  – Tail app log (e.g.hcom-log hwa)"
    echo "${boldtext}hcom_rm_logs${normaltext}"
    echo "   – Removes all tomcat log files"
    echo "${boldtext}hcom_get_revision [force] \$APPNAME${normaltext}"
    echo "   – Get latest p4 revision (cap/hwa/la/sp/mvt)"
    echo "${boldtext}hcom_dev${normaltext}"
    echo "   – cd to dev directory"
    echo "${boldtext}hcom_env${normaltext}"
    echo "   – cd to env directory"
    echo "${boldtext}hcom_app_restart \$APPNAME${normaltext}"
    echo "   – restarts app"
    echo "${boldtext}hcom_app_startwithlog \$APPNAME${normaltext}"
    echo "   – starts app and tails apps catalina.out"
    echo "${boldtext}hcom_app_all \$APPNAME${normaltext}"
    echo "   – stops, gets latest revisions, builds and starts all apps"
    echo ""
}
