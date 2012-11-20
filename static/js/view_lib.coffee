window.___ = (x) -> console.log x
window._mass_from_radius = (r) -> r*r*Math.PI
window._radius_from_mass = (m) -> Math.sqrt m/Math.PI
window._norm = (x, y) -> [x/(f=Math.sqrt x*x+y*y), y/f]
window._clr = (__, w, h=w) -> __.clearRect 0, 0, w, h

window._label_height = 20
window._white = 'rgba(255,255,255,1.0)'
window._text_base = (__, color=_white) ->
  __.font = "normal #{_label_height}px monospace"
  __.fillStyle = color
  __.textBaseline = 'bottom'

window._text_top = (__, side, color) ->
  if side is 'right'
    _text_base __, ((one.color __.fillStyle).alpha 0.2).cssa()
  else
    _text_base __, color
  __.textAlign = side

window._m_annotate = (__, mote, txt, opts={}) ->
  {x:x, y:y, radius:r} = mote
  {side:side, color: color, line: line} = _.defaults opts, side: 'right', color: null, line: 0
  _text_top __, side, color
  [label_x, label_y] = [_a*x, _a*(y-r)-line*_label_height]
  __.fillText txt, label_x, label_y
