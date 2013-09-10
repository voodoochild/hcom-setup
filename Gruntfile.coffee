module.exports = (grunt) ->

  # Configuration.
  grunt.initConfig

    # Parse the package.json file.
    pkg: grunt.file.readJSON('package.json')

    # Execute shell commands.
    #
    #   env                 configure the user environment to run HCOM apps.
    #   hosts               update /etc/hosts with developer endpoints.
    #   stubApps            create stub directories for each app
    #   buildProperties     copy build properties
    #   mvnSettings         copy maven settings
    exec:
      env:
        cmd: 'bash shell/env.sh'

      hosts:
        cmd: 'bash shell/hosts.sh'

      stubApps:
        cmd: 'bash shell/stub-apps.sh'

      buildProperties:
        cmd: 'bash shell/dev-build-properties.sh'

      mvnSettings:
        cmd: 'cp ../install/mvn-settings.xml ~/.m2/settings.xml'

  # Load external tasks.
  grunt.loadNpmTasks('grunt-exec')

  # Register a 'setup' task.
  grunt.registerTask('setup', ['env', 'hosts', 'stubApps', 'buildProperties', 'mvnSettings'])
