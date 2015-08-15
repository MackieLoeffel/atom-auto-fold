module.exports = AutoFold =
  # @auto-fold here
  activate: (state) ->
    console.log "daskdasd"
    atom.commands.add 'atom-workspace', 'auto-fold:toggle': => @toggle()

  deactivate: ->

  serialize: ->

  toggle: -> @fold()

  fold: (editor) ->
    editor ?= atom.workspace.getActiveTextEditor()

    foldNext = false
    for row in [0..editor.getLastBufferRow()]
      editor.toggleFoldAtBufferRow(row) if editor.isFoldableAtBufferRow(row) && foldNext
      foldNext = editor.isBufferRowCommented(row) && editor.lineTextForBufferRow(row).match(/@auto-fold here/)?
    console.log "dsadjs"
