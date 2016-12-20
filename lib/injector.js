(function() {
  var spurIoc;

  spurIoc = require("spur-ioc");

  module.exports = function() {
    var ioc;
    ioc = spurIoc.create("grunt-screenshot-compare-reporter");
    ioc.registerDependencies({
      "Promise": require("bluebird"),
      "mkdirp": require("mkdirp"),
      "_": require("underscore"),
      "path": require("path"),
      "fs": require("fs"),
      "imageDiff": require("image-diff")
    });
    ioc.registerFolders(__dirname, ["runtime/", "util/"]);
    return ioc;
  };

}).call(this);
