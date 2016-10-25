
module.exports = (options, domain, path, Util, Promise, fsPromise, FileDef, _, gm) ->

  {baselineDirectory, sampleDirectory} = options

  class ImageComparison

    THRESHOLD:0

    constructor: (@filename, @platform) ->
      @name = @filename.replace(".png", "")

      @diffFilepath = path.join(options.reportDirectory, @platform, @name+"-diff.png")
      @diffUrl = path.join(@platform, @name+"-diff.png")

    @compare: (filename, platform) ->
      new ImageComparison(filename, platform).compare()

    compare: () ->
      Util.promiseQueue [
        @copyFiles
        @runCompare
      ]

    copyFiles: () =>
      Promise.props({
        baselineFile:FileDef.makeCopy("baseline", @platform, @filename)
        sampleFile:FileDef.makeCopy("sample", @platform, @filename)
      }).then (results) => _.extend(@, results)


    runCompare: () =>
      unless @baselineFile.exists and @sampleFile.exists
        @result = {
          name:@name
          failed:true
          difference:0
          files:
            base:@baselineFile
            sample:@sampleFile
            diff:
              exists:false
        }
        Promise.resolve(@result)
      else
        @runGm()

    gmPromise: (image1, image2) ->
      new Promise (resolve, reject) =>
        d = domain.create()
        d.on "error", (e) ->
          resolve()
        d.run ->
          gm.compare(image1, image2, resolve)

    runGm: () ->
      @gmPromise(@sampleFile.filepath, @baselineFile.filepath)
        .then(@differenceResult)
        .catch (e) ->

    storeScreenshot: (rawData) ->
      data = rawData.replace(/^data:image\/png;base64,/,"")
      fsPromise.writeFileAsync(@diffFilepath, data, encoding:"base64")

    differenceResult: (difference) =>
      hasDifference = parseInt(difference.misMatchPercentage) > @THRESHOLD

      @result = {
        @name
        failed: hasDifference
        difference
        files: {
          sample:@sampleFile
          base:@baselineFile
          diff:
            exists:true
            filepath:@diffFilepath
            url:@diffUrl
        }
      }

      diffScreenshot = difference.getImageDataUrl()

      if diffScreenshot
        @storeScreenshot(diffScreenshot)
          .then => @result
      else
        Promise.resolve(@result)
