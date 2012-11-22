api = window._ai = {}
_lib = window._view_lib
ai_h = window._ai_helper

last_ejects = []
eject_throttle = 5
eject_min_radius = 0.01

wait_eject = (i, now) -> if (l=last_ejects[i])? then l + eject_throttle - now else 0

api.doit = (ctx, motes, now, strain) ->
  sames = _.filter motes, ai_h.same strain
  others = _.reject motes, ai_h.same strain

  move = if others.length is 0
    'done'
    #_.map sames, -> (now % 1000) * Math.PI
  else
    _.map sames, (mote, i) ->
      {x:x, y:y, vx:vx, vy:vy, radius:r} = mote
      if r > eject_min_radius
        targets = _.sortBy (_.filter others, (other) ->
          other.radius < r), (other) ->
            ai_h.distance mote, other

        wait = wait_eject i, now
        ai_h.draw_counter ctx, mote, wait/eject_throttle
        ai_h.draw_targets ctx, mote, targets

        if targets.length > 0 and wait <= 0
          last_ejects[i] = now
          target = _.first targets
          Math.PI + Math.atan2 target.y-y, target.x-x
        else null
      else null
  move
