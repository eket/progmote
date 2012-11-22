api = window._solo = {}
_lib = window._view_lib
view = window._view
ai = window._ai
arena = window._arena
fx = window._fixtures

api.done = no
api.ai_strain = null

context = null
motes = []
dt = 0.05
time = 0

_loop = _.throttle (->
  ___ '.'
  view.update motes

  ais = {}
  if api.ai_strain?
    move = ai.doit context, motes, time, api.ai_strain
    api.done = move is 'done'
    ais[api.ai_strain] = move unless api.done

  motes = arena.step motes, ais, dt
  time += dt
  _loop() unless api.done), 30

api.init = (cvs, ctx) ->
  _lib.add_event_listener cvs, 'down', (e) ->
    [x, y] = [(_lib.get_x e), (_lib.get_y e)]
    pick_strain x, y
  _lib.add_event_listener cvs, 'move', (e) ->
    prog = (_lib.get_x e)/view.a
    dt = prog/10

  context = ctx
  motes = arena.setup_random 50, fx.random_mote
  _.each motes, (m) -> m.vx = m.vy = 0
  _loop()

pick_strain = (x, y) ->
  picked = _.first _.sortBy motes, (mote) ->
    _lib.distance x, y, view.a*mote.x, view.a*mote.y
  api.ai_strain = picked.strain if picked?