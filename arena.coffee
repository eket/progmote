___ = (x) -> console.log x
_ = require 'underscore'

distance = (x0, y0, x1, y1) -> Math.sqrt (Math.pow x1-x0, 2)+(Math.pow y1-y0, 2)
dir = (n) -> if n < 0 then -1 else 1
norm = (x, y) -> [x/(f=Math.sqrt x*x+y*y), y/f]

mass_from_radius = (r) -> r*r*Math.PI
radius_from_mass = (m) -> Math.sqrt m/Math.PI

m_collide_with_view = (mote) ->
  {x: x, y: y, vx: vx, vy: vy, radius: r} = mote
  if 0>(d_x = _.min [x-r, 1-x-r])
    mote.x += d_x * dir mote.vx
    mote.vx *= -1
  if 0>(d_y = _.min [y-r, 1-y-r])
    mote.y += d_y * dir mote.vy
    mote.vy *= -1

m_displace = (mote, t) ->
  {vx: vx, vy: vy} = mote
  mote.x += vx * t
  mote.y += vy * t

m_overlaps_with_mote = (mote, other) ->
  d = distance mote.x, mote.y, other.x, other.y
  r = mote.radius + other.radius
  if d+1e-5 < r then [d, r-d] else no

m_collide_with_motes = (mote, motes) ->
  others = _.sortBy (_.reject motes, (other) =>
    other is mote or not m_overlaps_with_mote mote, other), 'radius'
  m_collide_with_mote mote, others.pop() unless others.length < 1

m_map_mass = (ms) -> _.map ms, (m) -> mass_from_radius m.radius
m_collide_with_mote = (mote, other) ->
  [loser, winner] = _.sortBy [mote, other], 'radius'
  d = distance loser.x, loser.y, winner.x, winner.y
  [m0, m1] = m_map_mass [loser, winner]
  sum = m0+m1
  r0 = 1/2*(d+Math.sqrt(2*sum/Math.PI - d*d))
  r1 = d-r0
  [r0, r1] = [(radius_from_mass sum), 0] if r1 < 0
  [loser.radius, winner.radius] = [r0, r1].sort()
  [m0_, m1_] = m_map_mass [loser, winner]
  dm = m0-m0_
  winner.vx = (m1*winner.vx+(dm)*loser.vx)/m1_
  winner.vy = (m1*winner.vy+(dm)*loser.vy)/m1_

m_eject = (mote, dm, dx, dy) ->
  {x: x0, y: y0, vx: vx0, vy: vy0, radius: r0} = mote
  m0 = mass_from_radius r0
  [dx, dy] = norm dx, dy
  dr = radius_from_mass dm
  m0_ = m0-dm
  r0_ = radius_from_mass m0_

  dmote =
    strain: mote.strain
    radius: dr
    x: x0+dx*1.1*(dr+r0_)
    y: y0+dy*1.1*(dr+r0_)
    vx: 0.5*dx
    vy: 0.5*dy

  mote.radius = r0_
  mote.vx = (m0*vx0-dm*dmote.vx)/m0_
  mote.vy = (m0*vy0-dm*dmote.vy)/m0_
  motes.push dmote

setup_random = (n, random_mote) ->
  for i in [0...n]
    while true
      break unless m_collide_with_view mote=random_mote()
    mote

do_ais = () ->
  _.map ais, (ai, strain) ->
    {sock: s, cmds: cmds} = ai
    ___ [strain, cmds]
    if s and cmds
      selves = _.filter motes, (m) -> m.strain is strain
      _.each cmds, (cmd) ->
        {act:act, i:i, arg: arg} = cmd
        m_eject selves[i], 0.0001, arg[0], arg[1] if act is 'eject'
    ai.cmds = []
  _loop()

ais_wait_id = null
T = 50 # time per round
rc = 0 # round counter
motes = []
_loop = _.throttle (->
  for mote in motes
    m_displace mote, T/1000.0 
    m_collide_with_view mote
    m_collide_with_motes mote, motes
  motes = _.reject motes, (m) -> m.radius <= 0
  rc += 1

  ___ "round #{rc}"
  s.emit 'update', motes for s in socks
  ais_wait_id = setTimeout do_ais, 2000), 30

Fixtures = require './fixtures.js'

ais = {}
socks = []
io = (require 'socket.io').listen 4567
io.sockets.on 'connection', (s) ->
  socks.push s
  s.on 'strain', (d) -> ais[d] = {sock:s}
  s.on 'cmds', (d) ->
    ais[d[0]] = {sock: s, cmds: d[1]}
    if (_.all (_.pluck ais, 'cmds'), (cmds) -> cmds?)
      clearTimeout ais_wait_id
      do_ais()

  motes = setup_random 20, Fixtures.random_mote
  _.each motes, (m) -> m.vx = m.vy = 0

  #motes = Fixtures.one
  ___ 'connected'
  _loop() unless rc > 0
