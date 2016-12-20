module.exports = (Promise) ->

  new class Util

    promiseQueue: (fns) ->
      queue = Promise.resolve(true)
      for fn in fns
        queue = queue.then(fn)
      queue
