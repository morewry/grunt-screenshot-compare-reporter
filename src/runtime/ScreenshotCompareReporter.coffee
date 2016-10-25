module.exports = (Util, Promise, _, FileUtils, PlatformReporter, options, HTMLReporter) ->

  class ScreenshotCompareReporter


    constructor: () ->
      @baselineDir = options.baselineDirectory
      @sampleDir = options.sampleDirectory
      @reportDir = options.reportDirectory


    run: () ->
      Util.promiseQueue([
        @getPlatforms
        @testPlaforms
        @writeHtmlReport
      ]).then () => @

    testPlaforms: () =>
      Promise.all(
        _.map(@platforms, PlatformReporter.run)
      ).then (results) =>
        @results = _.sortedIndexBy(results, "platform")


    getPlatforms: () =>
      FileUtils.flatDirectoryNames([@baselineDir, @sampleDir])
        .then (@platforms) =>

    writeHtmlReport: () =>
      HTMLReporter.write(@results)
