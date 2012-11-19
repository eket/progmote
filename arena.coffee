___ = (x) -> console.log x
_ = require 'underscore'
m = require './mote.js'

setup_random = (n, random_mote) ->
  for i in [0...n]
    while true
      break unless m.collide_with_view mote=random_mote(), off
    ___ mote
    mote

do_ais = (__) ->
  console.time 'ais'
  __ = _.map __, (ejects, strain) ->
    (_.each ejects, (angle, i) ->
      m.eject i, strain, motes, angle if angle?) if ejects?
    null
  console.timeEnd 'ais'
  _loop()

ais_wait_id = null
T = 50 # time per round
rc = 0 # round counter
motes = []
_loop = _.throttle (->
  console.time 'loop'
  motes = _.filter motes, (mote) ->
    return false if mote.radius <= 0
    m.displace mote, T/1000.0
    m.collide_with_view mote
    m.collide_mote mote, motes
    true
  rc += 1

  console.timeEnd 'loop'
  s.emit 'update', motes for s in socks
  ais_wait_id = setTimeout (->
    ___ 'ais timeout'
    do_ais ais), 2000), 30

Fixtures = require './fixtures.js'

ais = {}
socks = []
io = (require 'socket.io').listen 4567, 'log level': 1
io.sockets.on 'connection', (s) ->
  socks.push s
  s.on 'strain', (d) ->
    strain = d
    ais[strain] = null
  s.on 'ejects', (d) ->
    {strain: strain, ejects: ejects} = d
    ais[strain] = ejects
    all_done = _.all (_.values ais), (v) -> v?
    if all_done
      clearTimeout ais_wait_id
      do_ais ais

  #motes = Fixtures.one
  motes = setup_random 20, Fixtures.random_mote
  _.each motes, (m) -> m.vx = m.vy = 0

  ___ 'connected'
  _loop() unless rc > 0
