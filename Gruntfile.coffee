module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    
    copy:
      compile:
        expand: true
        cwd: 'src'
        src: ['**', '!**/*.{coffee,jade,styl}', '!**/_*']
        dest: 'public'
    
    coffee:
      compile:
        files: [
          src: 'server.coffee'
          dest: 'server.js'
        ,
          expand: true
          cwd: 'src'
          src: ['**/*.coffee']
          dest: 'public'
          ext: '.js'
        ]
    
    jade:
      compile:
        expand: true
        cwd: 'src'
        src: ['**/*.jade', '!**/_*']
        dest: 'public'
        ext: '.html'
    
    styl:
      options:
        whitespace: true
      compile:
        expand: true
        cwd: 'src'
        src: ['**/*.styl', '!**/_*']
        dest: 'public'
        ext: '.css'
    
    watch:
      options:
        livereload: true
      compile:
        files: 'src/**'
        tasks: ['copy', 'coffee', 'jade', 'styl']
          
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-styl'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  
  grunt.registerTask 'default', ['copy', 'coffee', 'jade', 'styl']
