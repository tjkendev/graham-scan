path = require('path')
webpack = require('webpack')

module.exports = (grunt)->
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
          new webpack.optimize.UglifyJsPlugin()
        )
    # grunt-contrib-jade
    jade:
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
    # grunt-contrib-uglify
    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        mangle: true
        compress: true
        report: 'gzip'
      target:
        src: 'public/js/app.js'
        dest: 'public/js/app.min.js'
    # grunt-image
    image:
      files: []
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
        tasks: ['webpack', 'uglify']
      # jade-html task
      jade_html:
        options:
          spawn: true
        files: [
          'src/jade-html/**/*.jade'
        ]
        tasks: ['jade']
      # less task
      less:
        options:
          spawn: true
        files: [
          'src/less/**/*.less'
        ]
        tasks: ['less:development', 'cssmin']
  )

  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-image'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffee-jshint'
  grunt.loadNpmTasks 'grunt-webpack'

  grunt.registerTask 'default', ['jade', 'less:development', 'cssmin', 'webpack', 'uglify']
