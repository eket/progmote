(exports ? this)._geom =
  distance: (x0, y0, x1, y1) ->
    Math.sqrt (Math.pow x1-x0, 2)+(Math.pow y1-y0, 2)
  norm: (x, y) -> [x/(f=Math.sqrt x*x+y*y), y/f]
  pi: Math.PI
