# HCOM Setup

Clone this into ~/hcom-dev/env.

1. Install `npm`, `nodejs` and `grunt-cli`.

	    brew install npm nodejs
	    npm install -g grunt-cli

2. Add `APP_PATH` and `ENV_PATH` to your `.bash_profile` (or equivalent)

    	export APP_PATH=~/hcom-dev/hcom
	    export ENV_PATH=~/hcom-dev/env
	    export P4PORT=dbcxlonperfx001.SEA.CORP.EXPECN.COM:1666
    	export P4USER=<your username>
	    export P4CLIENT=<your_username>_hcom_dev
	    source $ENV_PATH/setup/shell/hcom-profile.sh

	Save it, and `source ~/.bash_profile`.

3. If `p4` isn’t on your `$PATH`, add it to your `.bash_profile`

    	export PATH=$PATH:/path/to/directory/containing/p4

4. Run setup tasks using Grunt

	    cd $ENV_PATH/setup
	    npm install
	    grunt setup

5. Build the apps (run in separate tabs)

	    hcom_build cap
	    hcom_build hwa
	    hcom_build sha
	    hcom_build pda

6. Link the exploded WARs into the app directories

	    hcom_linkwar

7. Start the apps (run in separate tabs)

	    hcom_app_startwithlog cap
	    hcom_app_startwithlog hwa
	    hcom_app_startwithlog sha
	    hcom_app_startwithlog pda

### Optional aliases

These aliases may be useful. Add them to your .bash_profile if you want.

    alias ll="ls -lahF"
    alias java6='export JAVA_HOME=$JAVA6_HOME'
    alias java7='export JAVA_HOME=$JAVA7_HOME'

    alias hstart='hcom_app_startwithlog'
    alias hbuild='hcom_build'
    alias hupdate='hcom_updateui'
