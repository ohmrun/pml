default: test-interp
unit:
  hb build unit
test-interp:
  clear && hb build test/interp