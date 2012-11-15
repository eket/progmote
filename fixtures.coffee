strains = Object.keys (require './strains.js').strains
random_sign = -> if Math.random() > 0.5 then 1 else -1

random_mote = ->
  strain: strains[Math.floor Math.random() * strains.length]
  radius: 0.01+0.05*Math.random()
  x: Math.random()
  y: Math.random()
  vx: 0.07*Math.random()*random_sign()
  vy: 0.07*Math.random()*random_sign()

w_to_e =
  strain: 'yellow'
  radius: 0.15
  x: 1-0.32-0.15-0.0013
  y: 0.5
  vx: 0.001
  vy: 0

e_to_w =
  strain: 'blue'
  radius: 0.16
  x: 1-0.16
  y: 0.5
  vx: 0
  vy: 0

sw_to_ne =
  strain: 'green'
  radius: 0.07
  x: 0.2
  y: 0.8
  vx: 0.1
  vy: -0.1

nw_to_se =
  strain: 'red'
  radius: 0.1
  x: 0.2
  y: 0.2
  vx: 0.02
  vy: 0.02

food1 =
  strain: 'green'
  radius: 0.05
  x: 0.1
  y: 0.1
  vx: 0
  vy: 0

food2 =
  strain: 'green'
  radius: 0.075
  x: 0.8
  y: 0.2
  vx: 0
  vy: 0

mid =
  strain: 'orange'
  radius: 0.2
  x: 0.5
  y: 0.5
  vx: 0
  vy: 0

exports.random_mote = random_mote
exports.one = [mid, food1, food2]
exports.two = [e_to_w, w_to_e]
exports.three = [e_to_w, w_to_e, sw_to_ne]
