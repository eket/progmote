_distance = (x0, y0, x1, y1) -> Math.sqrt (Math.pow x1-x0, 2)+(Math.pow y1-y0, 2)
_distance2 = (a, b) -> _distance a.x, a.y, b.x, b.y
_now = -> Date.now()

_strain = null
_set_strain = (strain) ->
  _sock.emit 'strain', strain
  _strain = strain

_last_eject = null
_eject_throttle = 1000
_find_food = (__, motes) ->
  pred = (m) -> m.strain is _strain
  [selves, others] = [(_.filter motes, pred), (_.reject motes, pred)]
  n = _now()
  cmds = _.map selves, (self) ->
    size_limit = 1e-5 < (mass_from_radius self.radius)
    rate_limit = if _last_eject? then _last_eject + _eject_throttle < n else true
    if size_limit and rate_limit
      i = selves.indexOf self
      #_text_top _context, 'left'
      #__.fillText i, _a*self.x, _a*(self.y-self.radius)
      smallers = _.filter others, (ne) -> ne.radius < self.radius
      targets = _.sortBy smallers, (other) -> _distance2 self, other
      for other, j in targets
        r = j/targets.length
        __.strokeStyle = (one.color(_white).alpha 1-r).cssa()
        __.strokeStyle = (one.color('#ff0000')).css() if j is 0
        __.beginPath()
        __.moveTo _a*self.x, _a*self.y
        __.lineTo _a*other.x, _a*other.y
        __.stroke()
        #__.fillText "#{i}", _a*target.x, _a*(target.y-target.radius)-_label_height if target?
      if (t=targets[0])?
        _last_eject = n
        {act: 'eject', i: i, arg:[-t.x+self.x, -t.y+self.y]}
      else {}
    else {}

