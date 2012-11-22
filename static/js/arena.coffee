[API, _, M] =
  if exports?
    [exports._arena = {},
    (require 'underscore'),
    (require './mote')._mote]
  else
    [window._arena = {},
    window._,
    window._mote]

# <motes>: list of motes
# <ais>: hash of ais, where the keys are strain names and the values are moves

# assemble a list of random motes inside the view
# returns <motes>
API.setup_random = (n, random_mote) ->
  for i in [0...n]
    while true
      break unless M.collide_with_view mote=random_mote(), off
    mote

# compute the next <motes>
# <motes> before this step
# <ais> for this <motes>
# t: time delta of this step
API.step = (motes, ais, t) ->
  # apply the moves from the <ais>
  do_ais ais, motes
  # and compute the next <motes>
  motes = _.filter motes, (mote) ->
    # get rid of dead motes
    return false if mote.radius <= 0
    M.displace mote, t
    M.collide_with_view mote
    M.collide_mote mote, motes
    true
  motes

# apply the moves from <ais>
# <ais> to apply moves from
# <motes> to apply moves on
do_ais = (ais, motes) ->
  _.each ais, (ejects, strain) ->
    if ejects?
      _.each ejects, (angle, i) ->
        M.eject i, strain, motes, angle if angle?
