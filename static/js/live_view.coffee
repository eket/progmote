[API, VH, V, IO] =
  [window._live_view = {},
  window._view_helper,
  window._view,
  window.io]

API.ai_strain = null

motes = []
sock = null

API.init = (ctx) ->
  ___ 'initialize socket'
  sock = IO.connect ':4567'
  sock.on 'connect', ->
    ___ 'connected'
    sock.on 'update', (d) ->
      {motes: motes, time: time} = d
      V.update motes, time
      send_ejects ctx, motes, time if API.ai_strain?

send_ejects = (ctx, motes, time) ->
  if window._ai?
    ejects = window._ai.doit ctx, motes, time, API.ai_strain
    p = {strain: API.ai_strain, ejects: ejects}
    sock.emit 'ejects', p