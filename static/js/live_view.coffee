[API, VH, V, AI, IO] =
  [window._live_view = {},
  window._view_helper,
  window._view,
  window._ai,
  window.io]

API.ai_strain = null

motes = []
sock = null

API.init = (cvs, ctx) ->
  VH.add_event_listener cvs, 'down', (e) ->
    [x, y] = [(VH.get_x e), (VH.get_y e)]
    pick_strain x, y, ctx

  ___ 'initialize socket'
  sock = IO.connect ':4567'
  sock.on 'connect', ->
    ___ 'connected'
    sock.on 'update', (d) ->
      {motes: motes, time: time} = d
      V.update motes
      send_ejects ctx, motes, time if API.ai_strain?

send_ejects = (ctx, motes, time) ->
  ejects = AI.doit ctx, motes, time, API.ai_strain
  p = {strain: API.ai_strain, ejects: ejects}
  sock.emit 'ejects', p

pick_strain = (x, y, ctx) ->
  picked = _.first _.sortBy motes, (mote) ->
    VH.distance x, y, V.a*mote.x, V.a*mote.y
  API.ai_strain = picked.strain if picked?
  send_ejects ctx, motes, 0
