api = window._solo = {}
_lib = window._view_lib
view = window._view
ai = window._ai
arena = window._arena
fx = window._fixtures

api.done = no

context = null
motes = []
dt = 0.05
time = 0
_loop = _.throttle (->
  view.update motes
  motes = arena.step motes, dt
  time+=dt
  ___ '.'
  if api.ai_strain?
    move = ai.doit context, motes, time, api.ai_strain
    unless move is 'done'
      x={}
      x[api.ai_strain] = move
      arena.do_ais x, motes
      _loop()), 30

api.ai_strain = null
api.init = (cvs, ctx) ->
  _lib.add_event_listener cvs, 'down', (e) ->
    [x, y] = [(_lib.get_x e), (_lib.get_y e)]
    pick_strain x, y
  _lib.add_event_listener cvs, 'move', (e) ->
    prog = (_lib.get_x e)/view.a
    dt = prog/10
  context = ctx
  motes = arena.setup_random 20, fx.random_mote
  _.each motes, (m) -> m.vx = m.vy = 0
  _.times 5, _loop

pick_strain = (x, y) ->
  picked = _.first _.sortBy motes, (mote) ->
    _lib.distance x, y, view.a*mote.x, view.a*mote.y
  api.ai_strain = picked.strain if picked?
  _loop()