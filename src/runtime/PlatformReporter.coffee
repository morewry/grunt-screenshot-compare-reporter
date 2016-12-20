module.exports = (options, _, Util, Promise, FileUtils, path, ImageComparison, mkdirpAsync) ->


  class PlatformReporter

    constructor: (@platform) ->
      @baselinePlatform = path.join(options.baselineDirectory,@platform)
      @samplePlatform = path.join(options.sampleDirectory,@platform)

    @run: (platform) ->
      new PlatformReporter(platform).run()

    run: () ->
      Util.promiseQueue([
        @getAllFiles
        @createReportDir
        @compareFiles
      ]).then () => @

    createReportDir: () =>
      mkdirpAsync path.join(options.reportDirectory, @platform)

    getAllFiles: () =>
      FileUtils.flatFilenames([@baselinePlatform, @samplePlatform])
        .then (@filenames) =>

    compareFiles: () =>
      Promise.map(@filenames, @compareFile, {concurrency:10})
        .then (@results) =>
          console.log "compareFiles", arguments
          @results = _.compact(@results)

    compareFile: (filename) =>
      ImageComparison.compare(filename, @platform)
