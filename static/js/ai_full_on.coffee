[API, AIH, G] =
  [window._ai = {},
  window._ai_helper
  window._geom]

last_ejects = []
eject_throttle = 5

wait_eject = (i, now) -> if (l=last_ejects[i])? then l+eject_throttle-now else 0

API.doit = (ctx, motes, now, strain) ->
  sames = _.filter motes, AIH.same strain
  others = _.reject motes, AIH.same strain

  if others.length is 0 then 'done'
  else
    _.map sames, (mote, i) ->
      {x:x, y:y, vx:vx, vy:vy, radius:r} = mote
      targets = _.sortBy (_.filter others, (other) ->
        other.radius < r), (other) ->
          G.distance mote, other

      wait = wait_eject i, now
      AIH.draw_counter ctx, mote, wait/eject_throttle
      AIH.draw_targets ctx, mote, targets

      if targets.length > 0 and wait <= 0
        last_ejects[i] = now
        target = _.first targets
        G.pi + Math.atan2 target.y-y, target.x-x
      else null
