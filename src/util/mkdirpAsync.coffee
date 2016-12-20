module.exports = (Promise, mkdirp) ->
  Promise.promisify(mkdirp)