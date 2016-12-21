module.exports = (path, fsPromise, options, FileUtils) ->

  class FileDef

    constructor: (type, platform, filename) ->
      name = filename.replace(".png", "")

      fullPath = path.join(
        options["#{type}Directory"], platform, filename)

      @exists = fsPromise.existsSync(fullPath)
      if @exists
        @filepath = path.join(options.reportDirectory, platform, "#{name}-#{type}.png")
        @url = path.join(platform, "#{name}-#{type}.png")
        FileUtils.copyFile(fullPath, @filepath)
          .catch (e) =>
            delete @fullPath
            delete @url
            @exists = false


    @makeCopy: (type, platform, filename) ->
      new FileDef(type, platform, filename)