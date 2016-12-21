module.exports = (options, fsPromise, path, HTMLReporterTemplate) ->
  class HTMLReporter

    htmlReport: HTMLReporterTemplate

    constructor: (@report) ->
      @resultsDir = options.reportDirectory
      @failed = false

    @write: (report) ->
      new HTMLReporter(report).saveReport()

    addTestResult: (platform, results) ->
      @report[platform] = results
      @failed = true if results.filter((result) -> result.failed).length > 0

    addHtmlReportViewer: =>
      fsPromise.writeFileAsync(path.join(@resultsDir, "reporter.html"), @htmlReport)

    saveReport: =>
      fsPromise.writeFileAsync(path.join(@resultsDir, "results.js"), "window.results = #{JSON.stringify(@report)}")
        .then(@addHtmlReportViewer)
