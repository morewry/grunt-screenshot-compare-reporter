path = require("path")
fs = require("fs")
spurIoc = require("spur-ioc")

module.exports = () ->
  ioc = spurIoc.create("compare-reporter")

  ioc.registerDependencies {
    "Promise": require("bluebird")
    "resemble" : require("resemble")
    "mkdirp": require("mkdirp")
    "_": require("lodash")
    "path": require("path")
    "fs": require("fs")
    "domain": require("domain")
    "reportTemplate": fs.readFileSync(path.join(__dirname, "template/report.html"), "utf-8")
  }

  ioc.registerFolders __dirname, [
    "runtime/"
    "util/"
  ]

  ioc
