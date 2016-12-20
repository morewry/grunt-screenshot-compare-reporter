
module.exports = (options, domain, path, Util, Promise, fsPromise, FileDef, _, resemble) ->

  {baselineDirectory, sampleDirectory} = options

  class ImageComparison

    THRESHOLD: 0

    constructor: (@filename, @platform) ->
      # console.log "constructor", arguments
      @name = @filename.replace(".png", "")

      @diffFilepath = path.join(options.reportDirectory, @platform, @name+"-diff.png")
      @diffUrl = path.join(@platform, @name+"-diff.png")

    @compare: (filename, platform) ->
      # console.log "@compare", arguments
      new ImageComparison(filename, platform).compare()

    compare: () ->
      # console.log "compare", arguments
      Util.promiseQueue [
        @copyFiles
        @runCompare
      ]

    copyFiles: () =>
      # console.log "copyFiles", arguments
      Promise.props({
        baselineFile:FileDef.makeCopy("baseline", @platform, @filename)
        sampleFile:FileDef.makeCopy("sample", @platform, @filename)
      }).then (results) =>
        # console.log "copyFiles then", arguments
        _.extend(@, results)

    runCompare: () =>
      # console.log "runCompare", arguments
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
        @runResemble()

    resemblePromise:(image1, image2) ->
      # console.log "resemblePromise", arguments
      new Promise (resolve, reject) =>
        # console.log "new Promise"
        d = domain.create()
        d.on "error", (e) ->
          # console.log "d.on.error", arguments
          resolve()
        d.run ->
          # console.log "d.run", arguments
          resemble
            .resemble(image1)
            .compareTo(image2)
            .onComplete(resolve)

    runResemble:() ->
      # console.log "runResemble", arguments
      @resemblePromise(@sampleFile.filepath, @baselineFile.filepath)
        .then(@differenceResult)
        .catch (e) ->
          # console.log "runResemble catch", arguments

    storeScreenshot: (rawData) ->
      # console.log "storeScreenshot", arguments
      data = rawData.replace(/^data:image\/png;base64,/,"")
      fsPromise.writeFileAsync(@diffFilepath, data, encoding:"base64")

    differenceResult: (difference) =>
      console.log "differenceResult", arguments
      hasDifference = parseInt(difference.misMatchPercentage) > @THRESHOLD

      @result = {
        @name
        failed: hasDifference
        difference: difference
        files: {
          sample: @sampleFile
          base: @baselineFile
          diff:
            exists: true
            filepath: @diffFilepath
            url: @diffUrl
        }
      }

      diffScreenshot = difference.getImageDataUrl()

      if diffScreenshot
        @storeScreenshot(diffScreenshot)
          .then =>
            # console.log "differenceResult then", arguments
            Promise.resolve(@result)

      else
        Promise.resolve(@result)
