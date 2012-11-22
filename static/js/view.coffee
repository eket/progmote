api = window._view = {}
_lib = window._view_lib

api.a = null
canvas = null
context = null

resize = ->
  api.a = _.min [window.innerWidth, window.innerHeight]
  [canvas.width, canvas.height] = [api.a, api.a]
  ___ "resized canvas to #{api.a}x#{api.a}"

api.init = ->
  window.addEventListener 'resize', resize, no
  canvas = document.getElementById 'arena_canvas'
  context = canvas.getContext '2d'
  window._solo.init canvas, context
  resize()

api.update = (motes) ->
  _lib.clr context, api.a

  mass_sum = 0
  for mote in motes
    draw_mote context, mote
    mass_sum += _lib.mass_from_radius mote.radius

  _lib.text_top context, 'left'
  context.fillText (''+mass_sum)[0..10], api.a*0.01, api.a*0.99

draw_mote = (__, mote) ->
  strain = window._strains.colors[mote.strain]
  {x: x, y: y, vx: vx, vy: vy, radius: r} = mote
  [nx, ny] = _lib.norm vx, vy
  __.strokeStyle = __.fillStyle = strain.color
  __.beginPath()
  __.arc api.a*x, api.a*y, api.a*r, 0, 2*Math.PI, no
  __.fill()

  m = _lib.mass_from_radius r
  _lib.m_annotate __, mote, "r #{(''+r)[0..7]}"
  _lib.m_annotate __, mote, "m #{(''+m)[0..7]}", line: 1

  __.lineWidth = 2
  __.beginPath()
  scale = 50
  __.moveTo api.a*x, api.a*y
  __.lineTo api.a*(x+r*vx*scale+r*nx), api.a*(y+r*vy*scale+r*ny)
  __.stroke()
