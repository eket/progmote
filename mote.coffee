_ = require 'underscore'
g = require './geom'

sort2 = (a,b) -> if a > b then [b,a] else [a,b]
sort_by2 = (a,b,f) -> if (f a) > (f b) then [b,a] else [a,b]

exports.fun_mass = (r) -> r*r*Math.PI
exports.fun_mass_inv = (m) -> Math.sqrt m/Math.PI

exports.strains = _.keys (require './static/js/strains').strains
exports.distance = (mote, other) ->
  Math.sqrt (Math.pow other.x-mote.x, 2)+(Math.pow other.y-mote.y, 2)

exports.mass = (mote) -> exports.fun_mass mote.radius
exports.mass2 = (mote, other) -> [(exports.mass mote), (exports.mass other)]

exports.collide_with_view = (mote, bounce=on) ->
  {x: x, y: y, vx: vx, vy: vy, radius: r} = mote
  if 0 > d=x-r #left
    mote.x -= d
    mote.vx *= -1 if bounce
  else if 0 > d=1-x-r #right
    mote.x += d
    mote.vx *= -1 if bounce
  if 0 > d=y-r #top
    mote.y -= d
    mote.vy *= -1 if bounce
  else if 0 > d=1-y-r #bottom
    mote.y += d
    mote.vy *= -1 if bounce

exports.displace = (mote, t) ->
  mote.x += mote.vx * t
  mote.y += mote.vy * t

exports.overlaps = (mote, other) ->
  dist = exports.distance mote, other
  sum_r = mote.radius + other.radius
  if dist < sum_r then [dist, sum_r-dist] else no

exports.collide_mote = (mote, motes) ->
  others = _.sortBy (_.reject motes, (other) ->
    other is mote or not exports.overlaps mote, other), 'radius'
  exports.collision mote, others.pop() unless others.length < 1

exports.collision = (mote, other) ->
  [loser, winner] = sort_by2 mote, other, (m) -> m.radius
  d = exports.distance loser, winner
  [m0, m1] = exports.mass2 loser, winner
  sum_mass = m0+m1
  r0 = 1/2*(d+Math.sqrt(2*sum_mass/Math.PI - d*d))
  r1 = d-r0
  [r1, r0] = [0, exports.fun_mass_inv sum_mass] if r1 < 0
  [loser.radius, winner.radius] = sort2 r0, r1
  [m0_, m1_] = exports.mass2 loser, winner
  dm = m0-m0_
  winner.vx = (m1*winner.vx+(dm)*loser.vx)/m1_
  winner.vy = (m1*winner.vy+(dm)*loser.vy)/m1_

exports.eject = (i, strain, motes, angle) ->
  mote = (_.where motes, strain: strain)[i]
  {x: x0, y: y0, vx: vx0, vy: vy0, radius: r0} = mote
  return if r0 < 0.03
  m0 = exports.fun_mass r0
  dm = 0.02*m0
  angle += Math.PI if angle < 0
  [dx, dy] = [(Math.cos angle), (Math.sin angle)]
  dr = exports.fun_mass_inv dm
  m0_ = m0-dm
  r0_ = exports.fun_mass_inv m0_
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
