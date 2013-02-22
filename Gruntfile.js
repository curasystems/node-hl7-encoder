/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
   
    watch: {
      coffee: {
        files: 'src/**/*.coffee',
        tasks: 'coffee'
      }
    },
    coffee: {
      compile: {  
        options: {
          bare: true
        },
        files: [
          {
            expand: true,
            cwd: 'src',
            src: ['*.coffee'],
            dest: 'lib',
            ext: '.js'
          }
        ]
      }
      
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  
  // Default task.
  grunt.registerTask('default', ['coffee']);

};
