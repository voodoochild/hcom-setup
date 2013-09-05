module.exports = function(grunt) {

  // Config.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    exec: {
      // Configure the user environment to run HCOM apps.
      env: {
        cmd: 'bash shell/env.sh'
      },

      // Update /etc/hosts with developer endpoints.
      hosts: {
        cmd: 'bash shell/hosts.sh'
      },

      // Create stub directories for each app
      stubApps: {
        cmd: 'bash shell/stub-apps.sh'
      },

      // Copy build properties
      buildProperties: {
        cmd: 'bash shell/dev-build-properties.sh'
      },

      // Copy maven settings
      mvnSettings: {
        cmd: 'cp ../install/mvn-settings.xml ~/.m2/settings.xml'
      }
    }
  });

  // Load plugins.
  grunt.loadNpmTasks('grunt-exec');

  // Register tasks.
  grunt.registerTask('setup', ['env', 'hosts', 'stubApps', 'buildProperties', 'mvnSettings']);
};
