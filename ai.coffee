_distance = (x0, y0, x1, y1) -> Math.sqrt (Math.pow x1-x0, 2)+(Math.pow y1-y0, 2)
_distance2 = (a, b) -> _distance a.x, a.y, b.x, b.y
_now = -> Date.now()

_strain = null
_set_strain = (strain) ->
  _sock.emit 'strain', strain
  _strain = strain

_same_strain = (m) -> m.strain is _strain

_c_black = one.color '#000'
_c_white = one.color '#fff'
_c_red = one.color '#f00'

_ai_counter_darken = _c_black.alpha 0.2
_ai_counter_lighten = _c_white.alpha 0.2
_ai_draw_counter = (__, mote, wait) ->
  {x:x, y:y, radius:r} = mote
  __.fillStyle = (if wait > 0 then _ai_counter_darken else _ai_counter_lighten).cssa()
  __.beginPath()
  __.moveTo _a*x, _a*y
  passed = wait/_eject_throttle
  passed_a = (1-passed)*2*Math.PI
  start_a = -0.5*Math.PI
  __.arc _a*x, _a*y, _a*r, start_a, start_a+passed_a, no
  __.fill()

_ai_draw_targets = (__, mote, targets) ->
  _.each targets, (target, i) ->
    __.strokeStyle = if i is 0 then _c_red.css() else (_c_white.alpha 1-i/targets.length).cssa()
    __.beginPath()
    __.moveTo _a*mote.x, _a*mote.y
    __.lineTo _a*target.x, _a*target.y
    __.stroke()

_last_eject = []
_eject_throttle = 5000
_m_wait_eject = (i, now) ->
  if (last=_last_eject[i])?
    last+_eject_throttle-now
  else
    0

_ai_motes = null
_done = null
_doit = (__, motes) ->
  #_ai_motes = motes
  now = _now()
  sames = _.filter motes, _same_strain
  others = _.reject motes, _same_strain

  _done = others.length is 0 and sames.length is 1 if not _done
  return [{x:-1, y:-1}] if _done

  _.map sames, (mote, i) ->
    {x:x, y:y, vx:vx, vy:vy, radius:r} = mote
    if r > 0.01
      targets = _.sortBy (_.filter others, (other) ->
        other.radius < r), (other) ->
          _distance2 mote, other

      wait = _m_wait_eject i, now
      _ai_draw_counter __, mote, wait
      _ai_draw_targets __, mote, targets

      if targets.length > 0 and wait <= 0
        _last_eject[i] = now
        target = targets[0]
        {x: x-target.x, y:y-target.y}
      else {}
    else {}