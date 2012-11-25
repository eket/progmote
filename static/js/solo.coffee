[API, VH, V, AR, F, G] =
  [window._solo = {},
  window._view_helper,
  window._view,
  window._arena,
  window._fixtures,
  window._geom]

# semaphore to signal there's nothing to do
API.done = no
# current strain of the ai
API.ai_strain = null
API.ai_error = null
API.dt = 0.05
context = null
motes = []
time = 0

_loop = _.throttle (->
  ___ '.'
  V.update motes, time

  ais = {}
  if API.ai_strain? and not API.ai_error?
    # run the ai
    try
      move = window._ai?.doit context, motes, time, API.ai_strain
      API.done = move is 'done'
      ais[API.ai_strain] = move unless API.done
    catch err
      console.log 'error while calling ai'
      console.log API.ai_error = err

  # get the next <motes>
  motes = AR.step motes, ais, API.dt
  time += API.dt
  _loop() unless API.done), 30

# set up callbacks for the ai
API.init = (ctx) ->
  context = ctx
  motes = AR.setup_random 50, F.random_mote
  _.each motes, (m) -> m.vx = m.vy = 0
  _loop()

pick_strain = (x, y) ->
  picked = _.first _.sortBy motes, (mote) ->
    G.distance x, y, V.a*mote.x, V.a*mote.y
  API.ai_strain = picked.strain if picked?