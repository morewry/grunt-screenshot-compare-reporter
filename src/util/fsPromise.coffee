module.exports = (fs, Promise) ->
  Promise.promisifyAll(fs)
