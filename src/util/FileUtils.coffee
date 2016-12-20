module.exports = (fsPromise, path, Promise, _) ->

  new class FileUtils

    directoryFilter: (dir) -> (file) ->
      return false if file[0] is "."
      fsPromise.statAsync(path.join(dir,file))
        .then (stat) -> stat.isDirectory()

    fileFilter: (dir) -> (file) ->
      return false if file[0] is "."
      fsPromise.statAsync(path.join(dir,file))
        .then (stat) -> stat.isFile()

    getDirectories: (dir) =>
      fsPromise.readdirAsync(dir)
        .filter(@directoryFilter(dir))
        .catch () -> []

    getFiles: (dir) =>
      fsPromise.readdirAsync(dir)
        .filter(@fileFilter(dir))
        .catch () -> []

    flattenUniq: (results) -> _.uniq _.flatten(results)

    flatDirectoryNames: (directories) ->
      Promise.all(_.map(directories, @getDirectories))
        .then(@flattenUniq)

    flatFilenames: (directories) ->
      Promise.all(_.map(directories, @getFiles))
        .then(@flattenUniq)

    copyFile: (file, dest) -> new Promise (resolve, reject) ->
      rs = fsPromise.createReadStream(file)
      ws = fsPromise.createWriteStream(dest)
      rs.on "close", resolve
      rs.on "error", reject
      ws.on "error", reject
      rs.pipe(ws)
