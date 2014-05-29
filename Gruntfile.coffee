module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt

  grunt.initConfig
    project:
      src: 'src'
      dist: 'public'

    # Watches files for changes and runs tasks based on the changed files
    watch:
      coffee:
        files: ["<%= project.src %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["newer:coffee:dist"]

      styl:
        files: ["<%= project.src %>/styles/*.styl"]
        tasks: ["newer:styl:compile"]

      jade:
        files: ['<%= project.src %>/{,*/}*.jade']
        tasks: ['jade']


      gruntfile:
        files: ["Gruntfile.coffee"]
        tasks: ['build']


      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          "staging/{,*/}*.html"
          "staging/styles/{,*/}*.css"
          "staging/scripts/{,*/}*.js"
          "<%= project.src %>/img/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    # The actual grunt server settings
    connect:
      options:
        port: 9000
        livereload: 35729
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "0.0.0.0"

      livereload:
        options:
          open: true
          base: [
            "staging"
            "<%= project.src %>"
          ]

      dist:
        options:
          open: true
          livereload: false
          base: "<%= project.dist %>"

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            "staging"
            "<%= project.dist %>/*"
            "!<%= project.dist %>/.git*"
          ]
        ]

      server: "staging"

    shell:
      makepubs:
        options:
          execOptions:
            cwd: '<%= project.src %>/pubs'

        command: [
          './bib2jade.py journals.bib > _journals.jade'
          './bib2jade.py books.bib > _books.jade'
        ].join('&&')

    # Compiles .coffee files
    coffee:
      options:
        sourceMap: true
        sourceRoot: ""

      dist:
        files: [
          expand: true
          cwd: "<%= project.src %>"
          src: "scripts/{,*/}*.coffee"
          dest: "staging"
          ext: ".js"
        ]

    # Compiles .jade files
    jade:
      dist:
        options:
          pretty: true
          data:
            projects:
              color_denoising: 'Color Denoising'
              color_shading: 'Color/Shading Interaction'
              edge_line: 'Edge/Line Detection'
              neuroscience: 'Computational Neuroscience'
              psychophysics: 'Psychophysics'
              shading_occlusion: 'Shading-Based Occlusion Analysis'
              texture_flows: 'Texture Flows'
              shock_graphs: 'Shock Graphs & Shape Matching'
              stereo: 'Stereo'

        files: [
          expand: true
          cwd: '<%= project.src %>'
          dest: 'staging'
          src: ['{,*/}*.jade', '!{,*/}_*']
          ext: '.html'
        ]

    # Compiles .styl files
    styl:
      options:
        whitespace: true
        configure: (styl) ->
          styl.use require('rework-vars')()
          styl.use require('rework-calc')

      compile:
        expand: true
        cwd: '<%= project.src %>'
        src: ['styles/*.styl', '!styles/_*']
        dest: 'staging'
        ext: '.css'

    # Renames files for browser caching purposes
    filerev:
      dist:
        files: [
          src: [
            "<%= project.dist %>/scripts/{,*/}*.js"
            "<%= project.dist %>/styles/{,*/}*.css"
            "<%= project.dist %>/img/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
            "<%= project.dist %>/styles/fonts/*"
          ]
        ]

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: "staging/index.html"
      options:
        root: "staging"
        dest: "<%= project.dist %>"

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      options:
        assetsDirs: [
          "<%= project.dist %>"
        ]
      html: ["<%= project.dist %>/{,*/}*.html"]
      css: ["<%= project.dist %>/styles/{,*/}*.css"]

    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= project.src %>/img"
          src: "{,*/}*.{png,jpg,jpeg,gif}"
          dest: "<%= project.dist %>/img"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= project.src %>/img"
          src: "{,*/}*.svg"
          dest: "<%= project.dist %>/img"
        ]

    htmlmin:
      dist:
        options:
          collapseWhitespace: true
          collapseBooleanAttributes: true
          removeCommentsFromCDATA: true
          removeOptionalTags: true

        files: [
          expand: true
          cwd: "<%= project.dist %>"
          src: ["{,*/}*.html"]
          dest: "<%= project.dist %>"
        ]

    # Replace Google CDN references
    cdnify:
      dist:
        html: ["staging/*.html"]

    # Copies remaining files to places other tasks can use
    copy:
      stage:
        files: [
          expand: true
          cwd: '<%= project.src %>'
          dest: 'staging'
          src: [
            'styles/{,*/}*.css'
            'scripts/{,*/}*.js'
          ]
        ]

      dist:
        files: [
          expand: true
          cwd: 'staging'
          dest: '<%= project.dist %>'
          src: [
            '{,*/}*.html'
            'scripts/{,*/}*.js'
          ]
        ]

    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        "coffee:dist"
        "styl"
        "jade"
      ]
      dist: [
        "coffee"
        "styl"
        "jade"
      ]

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run [
        "connect:dist:keepalive"
      ]

    grunt.task.run [
      "clean:server"
      "concurrent:server"
      "connect:livereload"
      "watch"
    ]

  grunt.registerTask "build", [
    "clean:dist"
    "shell:makepubs"
    "concurrent:dist"
    "copy:stage"
    "useminPrepare"
    "concat"
    "copy:dist"
    "imagemin"
    "cssmin"
    "filerev"
    "usemin"
    "htmlmin"
  ]

  grunt.registerTask "default", [
    "build"
  ]
