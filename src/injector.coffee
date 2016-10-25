spurIoc = require("spur-ioc")

module.exports = () ->
  ioc = spurIoc.create("compare-reporter")

  ioc.registerDependencies {
    "Promise": require("bluebird")
    "gm" : require("gm").subClass({ imageMagick: true })
    "mkdirp": require("mkdirp")
    "_": require("lodash")
    "path": require("path")
    "fs": require("fs")
    "domain": require("domain")
  }

  ioc.registerFolders __dirname, [
    "runtime"
    "util"
  ]

  ioc
