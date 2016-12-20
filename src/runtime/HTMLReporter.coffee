module.exports = (options, fsPromise, path, reportTemplate) ->

  class HTMLReporter

    htmlReport: reportTemplate

    constructor: (@report) ->
      @resultsDir = options.reportDirectory
      @failed = false

    @write: (report) ->
      new HTMLReporter(report).saveReport()

    addTestResult: (platform, results) ->
      @report[platform] = results
      @failed = true if results?.filter((result) -> result.failed ).length > 0

    addHtmlReportViewer: =>
      fsPromise.writeFileAsync(path.join(@resultsDir, "reporter.html"), @htmlReport)

    saveReport: =>
      console.log "saveReport", arguments, @
      fsPromise.writeFileAsync(path.join(@resultsDir, "results.js"), "window.results = #{JSON.stringify(@report)}")
        .then(@addHtmlReportViewer)
