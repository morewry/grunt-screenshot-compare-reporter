spurIoc = require("spur-ioc")

module.exports = () ->
  ioc = spurIoc.create("grunt-screenshot-compare-reporter")

  ioc.registerDependencies {
    "Promise": require("bluebird")
    "mkdirp": require("mkdirp")
    "_": require("underscore")
    "path": require("path")
    "fs": require("fs")
    "imageDiff": require("image-diff")
  }

  ioc.registerFolders __dirname, [
    "runtime/",
    "util/"
  ]

  ioc
