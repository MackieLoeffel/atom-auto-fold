# @auto-fold regex /^\s*if/

if 1 == 2 then
  console.log "a"
else
  if 2 == 4 then
    console.log "b"
  console.log
    a:
      1
    # @auto-fold here
    b:
      c: "x"
      d: "y"
    d: //
      e: "z"
      f: "q"
