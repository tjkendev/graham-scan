path = require('path')
webpack = require('webpack')

module.exports = (grunt) ->
  webpackConfig = require('./webpack.config.js')
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
    # grunt-webpack
    webpack:
      options: webpackConfig
      build:
        plugins: webpackConfig.plugins.concat(
          new webpack.DefinePlugin(
            "process.env":
              "NODE_ENV": JSON.stringify("production")
          ),
        )
    # grunt-contrib-pug
    pug:
      html:
        options:
          pretty: true
        files: [
          expand: true
          cwd: 'src/jade-html/'
          src: '**/*.jade'
          dest: 'public/'
          ext: '.html'
        ]
    # grunt-contrib-less
    less:
      development:
        files: [
          src: 'src/less/**/*.less'
          dest: 'public/css/app.css'
        ]
      production:
        options:
          cleancss: true
        files: [
          src: 'src/less/**/*.less'
          dest: 'public/css/app.css'
        ]
    # grunt-contrib-cssmin
    cssmin:
      target:
        src: 'public/css/app.css'
        dest: 'public/css/app.min.css'
    # grunt-contrib-watch
    watch:
      # webpack task
      webpack:
        options:
          spawn: true
        files: [
          'src/coffee/**/*.coffee'
          'src/jade/**/*.jade'
          'webpack.config.js'
        ]
        tasks: ['webpack']
      # jade-html task
      jade_html:
        options:
          spawn: true
        files: [
          'src/jade-html/**/*.jade'
        ]
        tasks: ['pug']
      # less task
      less:
        options:
          spawn: true
        files: [
          'src/less/**/*.less'
        ]
        tasks: ['less:development', 'cssmin']
  )

  grunt.loadNpmTasks 'grunt-contrib-pug'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffee-jshint'
  grunt.loadNpmTasks 'grunt-webpack'

  grunt.registerTask 'default', ['pug', 'less:development', 'cssmin', 'webpack']
