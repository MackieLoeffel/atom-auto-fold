module.exports = AutoFold =
  config:
    autofold:
      title: "Auto-fold new files"
      description: "Automatically auto-fold new files, when they are opened"
      type: 'boolean'
      default: true
    defaultNextLineMarker:
      title: "Default next line Marker"
      description: "Marker triggering auto-fold on the next line. Should appear in commented part of line."
      type: 'string'
      default: '@auto-fold here'
    defaultMarkerRegexes:
      title: "Default regular expression markers"
      description: """
        Global regular expressions, which are used for marking lines. Like a global @auto-fold regex
        Example: /\\/\\/\\s*$/
      """
      type: 'string'
      default: ""

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'auto-fold:toggle': => @toggle()
    atom.commands.add 'atom-workspace', 'auto-fold:fold': => @fold()
    atom.commands.add 'atom-workspace', 'auto-fold:unfold': => @unfold()

    if atom.config.get('auto-fold.autofold')
      atom.workspace.observeTextEditors (editor) =>
        editor.displayBuffer.tokenizedBuffer.onDidTokenize =>
          @doFold 'fold', editor

    atom.config.observe 'auto-fold.defaultMarkerRegexes', (value) =>
      @defaultRegexes = @parseRegexLine value

  toggle: -> @doFold "toggle"
  fold: -> @doFold "fold"
  unfold: -> @doFold "unfold"

  parseRegexLine: (line) ->
    re = /\/(.*?[^\\])\//g
    new RegExp(m[1]) while (m = re.exec line)?

  doFold: (action, editor) ->
    editor ?= atom.workspace.getActiveTextEditor()
    defaultNextLineMarker = atom.config.get('auto-fold.defaultNextLineMarker')

    regexes = []
    regexes.push @defaultRegexes...
    for row in [0..editor.getLastBufferRow()]
      continue unless editor.isBufferRowCommented(row)
      if editor.lineTextForBufferRow(row).indexOf("@auto-fold regex") != -1
        regexes.push @parseRegexLine(editor.lineTextForBufferRow(row))...
      break

    eachRow = (f) ->
      foldNext = false
      any = false
      for row in [0..editor.getLastBufferRow()]
        if editor.isFoldableAtBufferRow(row) && (foldNext || regexes.some((r) -> editor.lineTextForBufferRow(row).match(r)?))
          any = true if f(row)
        foldNext = editor.isBufferRowCommented(row) && editor.lineTextForBufferRow(row).indexOf(defaultNextLineMarker) != -1
      return any

    if action == 'toggle'
      action = if eachRow((row) -> editor.isFoldedAtBufferRow(row)) then 'unfold' else 'fold'

    if action == "fold"
      eachRow (row) -> editor.foldBufferRow(row) unless editor.isFoldedAtBufferRow(row)
    else
      eachRow (row) -> editor.unfoldBufferRow(row) if editor.isFoldedAtBufferRow(row)
