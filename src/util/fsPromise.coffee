module.exports = (Promise, fs) ->
  Promise.promisifyAll(fs)
