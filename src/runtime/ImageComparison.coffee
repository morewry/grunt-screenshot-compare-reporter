module.exports = (options, path, Util, Promise, FileDef, _, imageDiff) ->

  {baselineDirectory, sampleDirectory} = options

  class ImageComparison

    THRESHOLD: 0

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
        baselineFile: FileDef.makeCopy("baseline", @platform, @filename)
        sampleFile: FileDef.makeCopy("sample", @platform, @filename)
      }).then (results) =>
        _.extend(@, results)

    runCompare: () =>
      unless @baselineFile.exists and @sampleFile.exists
        @result = {
          name: @name
          failed: true
          difference: 0
          files:
            base: @baselineFile
            sample: @sampleFile
            diff:
              exists: false
        }
        Promise.resolve(@result)
      else
        @runResemble()

    runResemble: () ->
      new Promise (resolve, reject) =>
        imageDiff.getFullResult {
          actualImage: @sampleFile.filepath
          expectedImage: @baselineFile.filepath
          diffImage: @diffFilepath
        }, (error, result) =>
          reject(error) if error
          resolve(@differenceResult(result)) unless error

    differenceResult: (difference) =>
      hasDifference = difference?.percentage > @THRESHOLD
      @result = @getDifferenceObject(difference, hasDifference)
      diffScreenshot = difference?.getImageDataUrl?()
      Promise.resolve(@result)

    getDifferenceObject: (difference, hasDifference) =>
      {
        @name
        failed: hasDifference
        difference
        files: {
          sample: @sampleFile
          base: @baselineFile
          diff:
            exists: true
            filepath: @diffFilepath
            url: @diffUrl
        }
      }
