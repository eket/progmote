_distance = (x0, y0, x1, y1) -> Math.sqrt (Math.pow x1-x0, 2)+(Math.pow y1-y0, 2)
_distance2 = (a, b) -> _distance a.x, a.y, b.x, b.y
_now = -> Date.now()

_strain = null
_self_pred = (m) -> m.strain is _strain
_set_strain = (strain) ->
  _sock.emit 'strain', strain
  _strain = strain

_last_eject = []
_eject_throttle = 5000
_find_food = (__, motes) ->
  n = _now()
  selves = _.filter motes, _self_pred
  others = _.reject motes, _self_pred

  _.map selves, (self, i) ->
    if self.radius > 0.01
      {x:x, y:y, vx:vx, vy:vy, radius:r} = self
      targets = _.sortBy (_.filter others, (o) ->
        o.radius < r), (t) ->
        _distance2 self, t

      if (l=_last_eject[i])?
        __.fillStyle = ((one.color '#000').alpha 0.2).cssa()
        __.beginPath()
        __.moveTo _a*x, _a*y
        passed = (l+_eject_throttle-n)/_eject_throttle
        passed_a = (1-passed)*2*Math.PI
        start_a = -0.5*Math.PI
        __.arc _a*x, _a*y, _a*r, start_a, start_a+passed_a, no
        __.fill()

      _.each targets, (t, ti) ->
        __.strokeStyle = ((one.color _white).alpha 1-ti/targets.length).cssa()
        __.strokeStyle = (one.color '#f00').css() if ti is 0
        __.beginPath()
        __.moveTo _a*x, _a*y
        __.lineTo _a*t.x, _a*t.y
        __.stroke()

      if targets.length > 0 and (not (l=_last_eject[i])? or (l+_eject_throttle<n))
        _last_eject[i] = n
        target = targets[0]
        {x: x-target.x, y:y-target.y}
      else {}
    else {}