# @auto-fold regex /^\s+serialize/ /^fold/
module.exports = AutoFold =
  config:
    autofold:
      title: "Auto-fold new files"
      description: "Automatically auto-fold new files, when they are opened"
      type: 'boolean'
      default: true

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'auto-fold:toggle': => @toggle()
    atom.commands.add 'atom-workspace', 'auto-fold:fold': => @fold()
    atom.commands.add 'atom-workspace', 'auto-fold:unfold': => @unfold()

    if atom.config.get('auto-fold.autofold')
      atom.workspace.observeTextEditors (editor) =>
        editor.displayBuffer.tokenizedBuffer.onDidTokenize =>
          @doFold('fold', editor)

  # @auto-fold here
  deactivate: ->
    console.log "dascasds"

  serialize: ->
    console.log "dascasds"

  toggle: -> @doFold("toggle")
  fold: -> @doFold "fold"
  unfold: -> @doFold "unfold"

  doFold: (action, editor) ->
    editor ?= atom.workspace.getActiveTextEditor()

    regexes = []
    for row in [0..editor.getLastBufferRow()]
      continue unless editor.isBufferRowCommented(row)
      if editor.lineTextForBufferRow(row).indexOf("@auto-fold regex") != -1
        editor.lineTextForBufferRow(row).replace /\/(.*?)\//g, (m, regex) ->
          regexes.push new RegExp(regex)
          return m
      break

    eachRow = (f) ->
      foldNext = false
      any = false
      for row in [0..editor.getLastBufferRow()]
        if editor.isFoldableAtBufferRow(row) && (foldNext || regexes.some((r) -> editor.lineTextForBufferRow(row).match(r)?))
          #console.log editor.lineTextForBufferRow row
          any = true if f(row)
        foldNext = editor.isBufferRowCommented(row) && editor.lineTextForBufferRow(row).indexOf("@auto-fold here") != -1
      return any

    if action == 'toggle'
      action = if eachRow((row) -> editor.isFoldedAtBufferRow(row)) then 'unfold' else 'fold'

    if action == "fold"
      eachRow (row) -> editor.foldBufferRow(row) unless editor.isFoldedAtBufferRow(row)
    else
      eachRow (row) -> editor.unfoldBufferRow(row) if editor.isFoldedAtBufferRow(row)
