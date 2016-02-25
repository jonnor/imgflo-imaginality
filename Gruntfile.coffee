
webpack = require "webpack"
webpackConfig = require "./webpack.config.js"

module.exports = ->
  # Project configuration
  pkg = @file.readJSON 'package.json'

  @initConfig
    webpack:
      options: webpackConfig
      build:
        plugins: webpackConfig.plugins.concat()
      "build-dev":
        devtool: "sourcemap"
        debug: true

    "webpack-dev-server":
      options: 
        webpack: webpackConfig
        publicPath: "/" + webpackConfig.output.publicPath
        port: 8099
      start:
        keepAlive: true
        webpack:
          devtool: "eval"
          debug: true

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-webpack'

  # Grunt plugins used for testing



  # Our local tasks
  @registerTask 'build', ['webpack']
  @registerTask 'dev', ['webpack-dev-server:start']
  @registerTask 'default', ['test']
