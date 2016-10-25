iocExtra = require("simple-ioc-extra")

module.exports = () ->
  ioc = iocExtra()
  ioc.reset()
  ioc.registerLibraries {
    "Promise"   :"bluebird"
    "mkdirp"    :"mkdirp"
    "_"         :"underscore"
    "path"      :"path"
    "gm"        :"gm"
  }

  ioc.registerDirectories __dirname, [
    "/runtime", "/util"
  ]

  ioc
