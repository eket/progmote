[api, _, m] =
  if exports?
    [exports._arena = {},
    (require 'underscore'),
    (require './mote')._mote]
  else
    [window._arena = {},
    window._,
    window._mote]

api.setup_random = (n, random_mote) ->
  for i in [0...n]
    while true
      break unless m.collide_with_view mote=random_mote(), off
    mote

api.step = (motes, ais, t) ->
  do_ais ais, motes
  motes = _.filter motes, (mote) ->
    return false if mote.radius <= 0
    m.displace mote, t
    m.collide_with_view mote
    m.collide_mote mote, motes
    true
  motes

do_ais = (ais, motes) ->
  _.each ais, (ejects, strain) ->
    if ejects?
      _.each ejects, (angle, i) ->
        m.eject i, strain, motes, angle if angle?
