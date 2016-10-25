(function() {
  var iocExtra;

  iocExtra = require("simple-ioc-extra");

  module.exports = function() {
    var ioc;
    ioc = iocExtra();
    ioc.reset();
    ioc.registerLibraries({
      "Promise": "bluebird",
      "mkdirp": "mkdirp",
      "_": "underscore",
      "path": "path",
      "gm": "gm"
    });
    ioc.registerDirectories(__dirname, ["/runtime", "/util"]);
    return ioc;
  };

}).call(this);
