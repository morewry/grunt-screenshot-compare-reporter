spurIoc = require("spur-ioc")
fs = require("fs")
path = require("path")

module.exports = () ->
  ioc = spurIoc.create("grunt-screenshot-compare-reporter")

  ioc.registerDependencies {
    "Promise": require("bluebird")
    "mkdirp": require("mkdirp")
    "_": require("underscore")
    "path": require("path")
    "fs": require("fs")
    "imageDiff": require("image-diff")
    "HTMLReporterTemplate": fs.readFileSync(path.join(__dirname, "../src/template/HTMLReporterTemplate.html"), {encoding: "utf-8"})
  }

  ioc.registerFolders __dirname, [
    "runtime/",
    "util/"
  ]

  ioc
