module.exports = (grunt) ->
  'use strict'

  pkg = require './package.json'

  grunt.initConfig 

    stylus: 
      dev: 
        options:
          paths: ['src/styles']
          urlfunc: 'embedurl'
          use:[ require 'fluidity' ]
        files: 
          'public/styles/main.css': 'src/styles/main.styl'

    jade: 
      templates:
        options:
          debug: false
          client: true
          pretty: false
          self: false
          locals: true
          runtime: true
          wrap:
            amd: true
            dependencies: '../runtime'
        files:
          'public/scripts/templates/': ['src/templates/**/*.jade']
      html:
        options:
          client: false
        files:
          'public': 'src/*.jade'

    clean:
      templates: [
        'public/scripts/runtime.js'
        'public/scripts/templates'
      ]

    urequire:
      dev:
        template: 'combined'
        path: 'src/scripts/'
        main: 'main'
        dstPath: 'public/scripts/main.js'
      prod:
        template: 'combined'
        path: 'src/scripts/'
        main: 'main'
        dstPath: 'public/scripts/main.js'
        optimize: 'uglify2'
        debugLevel: 0

    connect:
      dev:
        options:
          port: 9000
          base: 'public'
          middleware: (connect, options) -> [
            require('connect-url-rewrite') ['^([^.]+|.*\\?{1}.*)$ /']
            connect.static options.base
            connect.directory options.base
          ]

    watch:
      options:
        livereload: true

      jade: 
        files: 'src/templates/**/*.jade'
        tasks: [
          'jade:templates'
          'urequire:dev'
        ]
        options:
          interrupt: true

      index:
        files: 'src/*.jade'
        tasks: 'jade:html'
        options:
          interrupt: true

      stylus: 
        files: 'src/styles/*.styl'
        tasks: 'stylus:dev'
        options:
          interrupt: true

      urequire:
        files: [
          'src/scripts/**/*.coffee'
          'src/templates/**/*.jade'
        ]
        tasks: [
          'urequire:dev'
          'jade:templates'
        ]
        options:
          interrupt: true


  # Dependencies
  # ============
  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks name

  # Default task(s).
  grunt.registerTask 'dev', [
    'jade:templates'
    'jade:html'
    'urequire:dev'
    'stylus:dev'
    'connect:dev'
    'watch'
  ]

  grunt.registerTask 'prod', [
    'jade:templates'
    'jade:html'
    'urequire:prod'
    'clean:templates'
    'stylus:dev'
    'connect:dev'
  ]

  grunt.registerTask 'default', 'dev'
