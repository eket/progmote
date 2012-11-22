api = window._multi_view = {}

_lib = window._view_lib
view = window._view
ai = window._ai
motes = []
sock = null

api.ai_strain = null
api.init = (cvs, _ctx) ->
  _lib.add_event_listener cvs, 'down', (e) ->
    [x, y] = [(_lib.get_x e), (_lib.get_y e)]
    pick_strain x, y, _ctx
  ___ 'initialize socket'
  sock = io.connect ':4567'
  sock.on 'connect', ->
    ___ 'connected'
    sock.on 'update', (d) ->
      {motes: motes, time: time} = d
      view.update motes
      send_ejects _ctx, motes, time if api.ai_strain?

send_ejects = (_ctx, motes, time) ->
  ejects = ai.doit _ctx, motes, time, api.ai_strain
  p = {strain: api.ai_strain, ejects: ejects}
  sock.emit 'ejects', p

pick_strain = (x, y, _ctx) ->
  picked = _.first _.sortBy motes, (mote) ->
    _lib.distance x, y, view.a*mote.x, view.a*mote.y
  api.ai_strain = picked.strain if picked?
  send_ejects _ctx, motes, 0
