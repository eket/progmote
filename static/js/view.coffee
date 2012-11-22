api = window._view = {}
_lib = window._view_lib

api.a = null
sock = null
canvas = null
context = null

resize = ->
  api.a = _.min [window.innerWidth, window.innerHeight]
  [canvas.width, canvas.height] = [api.a, api.a]
  ___ "resized canvas to #{api.a}x#{api.a}"

api.init = ->
  ___ 'initialize canvas'
  canvas = document.getElementById 'arena_canvas'
  window.addEventListener 'resize', resize, no
  context = canvas.getContext '2d'
  _lib.add_event_listener canvas, 'down', (e) ->
    [x, y] = [(_lib.get_x e), (_lib.get_y e)]
    pick_strain x, y

  ___ 'initialize socket'
  sock = io.connect ':4567'
  sock.on 'connect', ->
    ___ 'connected'
    #_set_strain 'orange'
    sock.on 'update', (d) -> update d
  resize()

api.ai_strain = null
send_ejects = (__, motes, rc) ->
  ejects = _ai.doit __, motes, rc, api.ai_strain
  p = {strain: api.ai_strain, ejects: ejects}
  sock.emit 'ejects', p

pick_strain = (x, y) ->
  picked = _.first _.sortBy motes, (mote) ->
    _lib.distance x, y, api.a*mote.x, api.a*mote.y
  api.ai_strain = picked.strain if picked?
  send_ejects context, motes, 0

motes = null
update = (d) ->
  [motes, rc] = d
  motes = motes
  _lib.clr context, api.a

  mass_sum = 0
  for mote in motes
    draw_mote context, mote
    mass_sum += _lib.mass_from_radius mote.radius

  _lib.text_top context, 'left'
  context.fillText (''+mass_sum)[0..10], api.a*0.01, api.a*0.99

  send_ejects context, motes, rc if api.ai_strain?

draw_mote = (__, mote) ->
  strain = window._strains[mote.strain]
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
