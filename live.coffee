[API, _, F, AR, io] =
  [exports._multi = {},
  (require 'underscore'),
  (require './static/js/fixtures')._fixtures,
  (require './static/js/arena')._arena,
  (require 'socket.io')]
___ = (x) -> console.log x

ais = {}
motes = []
time = 0
dt = 0.05
ais_wait_id = null
socks = []

ais_ready = -> _.all (_.values ais), (v) -> v? 

multi_do_ais = ->
  motes = AR.step motes, ais, dt
  ___ time+=dt
  _loop()

_loop = _.throttle (->
  s.emit 'update', motes: motes, time: time for s in socks

  ais_wait_id = setTimeout (->
    ___ 'ais timeout'
    multi_do_ais()), 2000), 30


io = io.listen 4567, 'log level': 1
io.sockets.on 'connection', (s) ->
  socks.push s
  s.on 'ejects', (d) ->
    {strain: strain, ejects: ejects} = d
    ais[strain] = ejects
    if ais_ready()
      clearTimeout ais_wait_id
      multi_do_ais()

  #motes = Fixtures.one
  motes = AR.setup_random 20, F.random_mote
  _.each motes, (m) -> m.vx = m.vy = 0
  ___ 'connected'
  _loop() unless time > 0


