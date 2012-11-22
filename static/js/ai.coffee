api = window._ai = {}
_lib = window._view_lib

distance2 = (a, b) -> _lib.distance a.x, a.y, b.x, b.y

same = (strain) -> (m) -> m.strain is strain

_c_black = one.color '#000'
_c_white = one.color '#fff'
_c_red = one.color '#f00'

_ai_counter_darken = _c_black.alpha 0.2
_ai_counter_lighten = _c_white.alpha 0.2
_ai_draw_counter = (__, mote, wait) ->
  {x:x, y:y, radius:r} = mote
  __.fillStyle = (if wait > 0 then _ai_counter_darken else _ai_counter_lighten).cssa()
  __.beginPath()
  __.moveTo _view.a*x, _view.a*y
  passed = wait/_eject_throttle
  passed_a = (1-passed)*2*Math.PI
  start_a = -0.5*Math.PI
  __.arc _view.a*x, _view.a*y, _view.a*r, start_a, start_a+passed_a, no
  __.fill()

_ai_draw_targets = (__, mote, targets) ->
  _.each targets, (target, i) ->
    __.strokeStyle = if i is 0 then _c_red.css() else (_c_white.alpha 1-i/targets.length).cssa()
    __.beginPath()
    __.moveTo _view.a*mote.x, _view.a*mote.y
    __.lineTo _view.a*target.x, _view.a*target.y
    __.stroke()

_last_eject = []
_eject_throttle = 5
_m_wait_eject = (i, now) ->
  if (last=_last_eject[i])?
    last + _eject_throttle - now
  else
    0

_ai_motes = null

api.doit = (__, motes, rc, strain) ->
  #_ai_motes = motes
  #console.time 'doit'
  now = rc
  sames = _.filter motes, same strain
  others = _.reject motes, same strain

  r = if others.length is 0
    'done'
    #_.map sames, -> (now % 1000) * Math.PI
  else
    _.map sames, (mote, i) ->
      {x:x, y:y, vx:vx, vy:vy, radius:r} = mote
      if r > 0.01
        targets = _.sortBy (_.filter others, (other) ->
          other.radius < r), (other) ->
            distance2 mote, other

        wait = _m_wait_eject i, now
        _ai_draw_counter __, mote, wait
        _ai_draw_targets __, mote, targets

        if targets.length > 0 and wait <= 0
          _last_eject[i] = now
          target = targets[0]
          Math.PI + Math.atan2 target.y-y, target.x-x
        else null
      else null
  #console.timeEnd 'doit'
  r
