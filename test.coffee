# @auto-fold regex /^\s*if/

if 1 == 2 then
  console.log "a"
else
  if 2 == 4 then
    console.log "b"
  console.log
    a:
      1
    # @auto-fold next
    b:
      c: "x"
      d: "y"
    d: # @auto-fold here
      e: "z"
      f: "q"
