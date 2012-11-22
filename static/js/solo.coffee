[API, VH, V, AI, AR, F, G] =
  [window._solo = {},
  window._view_helper,
  window._view,
  window._ai,
  window._arena,
  window._fixtures,
  window._geom]

# semaphore to signal there's nothing to do
API.done = no
# current strain of the ai
API.ai_strain = null

context = null
motes = []
dt = 0.05
time = 0

_loop = _.throttle (->
  ___ '.'
  V.update motes, time

  ais = {}
  if API.ai_strain?
    # run the ai
    move = AI.doit context, motes, time, API.ai_strain
    API.done = move is 'done'
    ais[API.ai_strain] = move unless API.done

  # get the next <motes>
  motes = AR.step motes, ais, dt
  time += dt
  _loop() unless API.done), 30

# set up callbacks for the ai
API.init = (cvs, ctx) ->
  VH.add_event_listener cvs, 'down', (e) ->
    [x, y] = [(VH.get_x e), (VH.get_y e)]
    pick_strain x, y
  VH.add_event_listener cvs, 'move', (e) ->
    prog = (VH.get_x e)/V.a
    dt = prog/10

  context = ctx

  motes = AR.setup_random 50, F.random_mote
  _.each motes, (m) -> m.vx = m.vy = 0
  _loop()

pick_strain = (x, y) ->
  picked = _.first _.sortBy motes, (mote) ->
    G.distance x, y, V.a*mote.x, V.a*mote.y
  API.ai_strain = picked.strain if picked?