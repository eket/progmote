# globals
_a = null
_sock = null
_canvas = null
_context = null

_resize = ->
  _a = _.min [window.innerWidth, window.innerHeight]
  [_canvas.width, _canvas.height] = [_a, _a]
  ___ "resized canvas to #{_a}x#{_a}"

_init = ->
  ___ 'initialize canvas'
  _canvas = document.getElementById 'arena_canvas'
  window.addEventListener 'resize', _resize, no
  _context = _canvas.getContext '2d'

  ___ 'initialize socket'
  _sock = io.connect 'http://localhost:4567'
  _sock.on 'connect', ->
    ___ 'connected'
    _set_strain 'orange'
    _sock.on 'update', (d) -> _update d
  _resize()

_update = (d) ->
  _clr _context, _a  
  if _strain?
    cmds = _find_food _context, d
    _sock.emit 'cmds', [_strain, cmds]

  mass_sum = 0
  for mote in d
    _draw_mote _context, mote
    mass_sum += mass_from_radius mote.radius

  _text_top _context, 'left'
  _context.fillText (''+mass_sum)[0..10], _a*0.01, _a*0.99

_draw_mote = (__, mote) ->
  strain = Strains[mote.strain]
  {x: x, y: y, vx: vx, vy: vy, radius: r} = mote
  [nx, ny] = norm vx, vy
  __.strokeStyle = __.fillStyle =
  if mote.hl
    one.color(_white).cssa()
  else
    strain.color

  __.beginPath()
  __.arc _a*x, _a*y, _a*r, 0, 2*Math.PI, no
  __.fill()

  m = mass_from_radius r  
  radius_label = "r #{(''+r)[0..7]}"
  mass_label = "m #{(''+m)[0..7]}"
  kinetic_label = "k #{(''+(m*vx))[0..7]} #{(''+(m*vy))[0..7]}"
  label_y = _a*(y-r)
  _text_top __, 'right'
  __.fillText radius_label, _a*x, label_y
  __.fillText mass_label, _a*x, label_y-_label_height
  __.fillText kinetic_label, _a*x, label_y-2*_label_height

  __.lineWidth = 2
  __.beginPath()
  scale = 50
  __.moveTo _a*x, _a*y
  __.lineTo _a*(x+r*vx*scale+r*nx), _a*(y+r*vy*scale+r*ny)
  __.stroke()
