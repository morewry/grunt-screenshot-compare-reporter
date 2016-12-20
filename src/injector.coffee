iocExtra = require("simple-ioc-extra")

module.exports = ()->
  ioc = iocExtra()
  ioc.reset()
  ioc.registerLibraries {
    "Promise"   :"bluebird"
    "resemble"  :"resemble"
    "mkdirp"    :"mkdirp"
    "_"         :"underscore"
    "path"      :"path"
    "imageDiff" :"image-diff"
  }

  ioc.registerDirectories __dirname, [
    "/runtime", "/util"
  ]

  ioc
