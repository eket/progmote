# globals
window._a = null
window._sock = null
window._canvas = null
window._context = null

window._events =
  down: ['mousedown', 'touchstart']
  up: ['mouseup', 'touchend']
  move: ['mousemove', 'touchmove']
window._get_x = (e, i=0) -> e.targetTouches?[i].pageX or e.clientX
window._get_y = (e, i=0) -> e.targetTouches?[i].pageY or e.clientY
window._add_event_listener = (el, event_key, fun) ->
  el.addEventListener event, ((e) ->
    fun e
    e.preventDefault()), no for event in _events[event_key]

window._resize = ->
  window._a = _.min [window.innerWidth, window.innerHeight]
  [_canvas.width, _canvas.height] = [_a, _a]
  ___ "resized canvas to #{_a}x#{_a}"

window._init = ->
  ___ 'initialize canvas'
  window._canvas = document.getElementById 'arena_canvas'
  window.addEventListener 'resize', _resize, no
  window._context = _canvas.getContext '2d'
  _add_event_listener _canvas, 'down', (e) ->
    _pick_strain (_get_x e), (_get_y e)

  ___ 'initialize socket'
  window._sock = io.connect ':4567'
  _sock.on 'connect', ->
    ___ 'connected'
    #_set_strain 'orange'
    _sock.on 'update', (d) -> _update d
  _resize()

window._ai_strain = null
window._send_ejects = (__, motes, rc, strain) ->
  ejects = _doit __, motes, rc, strain
  p = {strain: strain, ejects: ejects}
  _sock.emit 'ejects', p

window._pick_strain = (x, y) ->
  picked = _.first _.sortBy _motes, (mote) -> _distance x, y, _a*mote.x, _a*mote.y
  window._ai_strain = picked.strain if picked?
  ___ window._ai_strain
  _send_ejects _context, _motes, 0

window._motes = null
window._update = (d) ->
  [motes, rc] = d
  window._motes = motes
  _clr _context, _a

  mass_sum = 0
  for mote in motes
    _draw_mote _context, mote
    mass_sum += _mass_from_radius mote.radius

  _text_top _context, 'left'
  _context.fillText (''+mass_sum)[0..10], _a*0.01, _a*0.99

  _send_ejects _context, motes, rc, _ai_strain if _ai_strain?

draw_mote = (__, mote) ->
  strain = window._strains[mote.strain]
  {x: x, y: y, vx: vx, vy: vy, radius: r} = mote
  [nx, ny] = _norm vx, vy
  __.strokeStyle = __.fillStyle = strain.color
  __.beginPath()
  __.arc _a*x, _a*y, _a*r, 0, 2*Math.PI, no
  __.fill()

  m = _mass_from_radius r
  _m_annotate __, mote, "r #{(''+r)[0..7]}"
  _m_annotate __, mote, "m #{(''+m)[0..7]}", line: 1

  __.lineWidth = 2
  __.beginPath()
  scale = 50
  __.moveTo _a*x, _a*y
  __.lineTo _a*(x+r*vx*scale+r*nx), _a*(y+r*vy*scale+r*ny)
  __.stroke()
