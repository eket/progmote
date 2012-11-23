[API, VH, M, G, S] =
  [window._view = {},
  window._view_helper,
  window._mote
  window._geom,
  window._strains.colors]

# canvas width in pixels
API.a = null

API.hud =
  # indicate mote speed with a line
  speed: on

  # line number of radius in annotations, negative disables
  radius: 0

  # line number of mass in annotations, negative disables
  mass: 1

  # indicate in-game time in lower left corner
  time: on

canvas = null
context = null

resize = ->
  API.a = _.min [window.innerWidth, window.innerHeight]
  [canvas.width, canvas.height] = [API.a, API.a]
  ___ "resized canvas to #{API.a}x#{API.a}"

# set up the html5 canvas and callbacks
API.init = ->
  window.addEventListener 'resize', resize, no
  canvas = document.getElementById 'arena_canvas'
  context = canvas.getContext '2d'
  window._solo.init context
  resize()

# update what's on the canvas
# <motes> to display
# time: in-game time
API.update = (motes, time) ->
  VH.clr context, API.a
  _.map motes, (mote) -> draw_mote context, mote

  if API.hud.time
    VH.set_text_over_point context, 'left', VH.white
    context.fillText (''+time)[0..7], API.a*0.01, API.a*0.99

draw_mote = (ctx, mote) ->
  {x: x, y: y, vx: vx, vy: vy, radius: r, strain: s} = mote
  # this is the mote itself
  ctx.fillStyle = S[s]
  ctx.beginPath()
  ctx.arc API.a*x, API.a*y, API.a*r, 0, 2*G.pi, no
  ctx.fill()

  if API.hud.radius >= 0
    VH.annotate ctx, mote, "r #{(''+r)[0..7]}", line: API.hud.radius
  if API.hud.mass >= 0
    mass = M.fun_mass r
    VH.annotate ctx, mote, "m #{(''+mass)[0..7]}", line: API.hud.mass
  if API.hud.speed
    [nx, ny] = G.norm vx, vy
    scale = 50
    ctx.strokeStyle = S[s]
    ctx.lineWidth = 2
    ctx.beginPath()
    ctx.moveTo API.a*x, API.a*y
    ctx.lineTo API.a*(x+r*vx*scale+r*nx), API.a*(y+r*vy*scale+r*ny)
    ctx.stroke()
