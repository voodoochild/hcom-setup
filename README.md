# Setting up an HCOM dev environment using Grunt

## Pre–requisites

    brew install npm nodejs
    npm install -g grunt-cli

## Initial setup

1. Add APP_PATH and ENV_PATH to your .bash_profile (or equivalent)

    export APP_PATH=~/hcom-dev/hcom
    export ENV_PATH=~/hcom-dev/env
    export P4PORT=dbcxlonperfx001.SEA.CORP.EXPECN.COM:1666
    export P4USER=<your username>
    export P4CLIENT=<your_username>_hcom_dev
    source $ENV_PATH/setup/shell/hcom-profile.sh

    $ source ~/.bash_profile

2. If `p4` isn’t on your PATH, add it to your .bash_profile

    export PATH=$PATH:/path/to/directory/containing/p4

3. Run setup tasks using Grunt

    cd $ENV_PATH/setup
    npm install
    grunt setup

4. Build the apps (run in separate tabs)

    hcom_build cap
    hcom_build hwa
    hcom_build sha
    hcom_build pda

5. Link the exploded WARs into the app directories

    hcom_linkwar

6. Start the apps (run in separate tabs)

    hcom_app_startwithlog cap
    hcom_app_startwithlog hwa
    hcom_app_startwithlog sha
    hcom_app_startwithlog pda

## Optional aliases

    alias ll="ls -lahF"
    alias java6='export JAVA_HOME=$JAVA6_HOME'
    alias java7='export JAVA_HOME=$JAVA7_HOME'

    alias hstart='hcom_app_startwithlog'
    alias hbuild='hcom_build'
    alias hupdate='hcom_updateui'
