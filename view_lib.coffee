___ = (x) -> console.log x
mass_from_radius = (r) -> r*r*Math.PI
radius_from_mass = (m) -> Math.sqrt m/Math.PI
norm = (x, y) -> [x/(f=Math.sqrt x*x+y*y), y/f]
_clr = (__, w, h=w) -> __.clearRect 0, 0, w, h

_label_height = 20
_white = 'rgba(255,255,255,1.0)'
_text_base = (__, color=_white) ->
  __.font = "normal #{_label_height}px monospace"
  __.fillStyle = color
  __.textBaseline = 'bottom'

_text_top = (__, side, color) ->
  if side is 'right'
    _text_base __, ((one.color __.fillStyle).alpha 0.2).cssa()
  else
    _text_base __, color
  __.textAlign = side