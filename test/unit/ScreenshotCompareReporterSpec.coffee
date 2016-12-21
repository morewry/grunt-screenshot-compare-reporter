path = require "path"

describe.only "ScreenshotCompareReporter", ->

  beforeEach ->
    @options =
      reportDirectory:path.resolve(__dirname, "../../test-results")
      sampleDirectory:path.resolve(__dirname, "../resources/baseline")
      baselineDirectory:path.resolve(__dirname, "../resources/sample")
    injector()
      .addDependency("options", @options)
      .inject (@ScreenshotCompareReporter)=>


    @reporter = new @ScreenshotCompareReporter(@options)

  it "should exist", ->
    expect(@ScreenshotCompareReporter).to.exist

  it.only "getPlatforms()", (done)->
    @reporter.getPlatforms().then (@results)=>
      expect(@reporter.platforms).to.deep.equal (
        [ 'LINUX_chrome_35', 'MAC_chrome_35', 'WINDOWS_chrome_35' ]
      )
      done()

  it "run()", (done)->
    @reporter.run().then ()=>
      console.log @reporter
      done()
