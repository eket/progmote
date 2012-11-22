window.___ = (x) -> console.log x

api = window._view_lib = {}
api.mass_from_radius = (r) -> r*r*Math.PI
api.radius_from_mass = (m) -> Math.sqrt m/Math.PI
api.norm = (x, y) -> [x/(f=Math.sqrt x*x+y*y), y/f]
api.clr = (__, w, h=w) -> __.clearRect 0, 0, w, h

api.label_height = 20
api.white = 'rgba(255,255,255,1.0)'
api.text_base = (__, color=api,white) ->
  __.font = "normal #{api.label_height}px monospace"
  __.fillStyle = color
  __.textBaseline = 'bottom'

api.text_top = (__, side, color) ->
  if side is 'right'
    api.text_base __, ((one.color __.fillStyle).alpha 0.2).cssa()
  else
    api.text_base __, color
  __.textAlign = side

api.m_annotate = (__, mote, txt, opts={}) ->
  {x:x, y:y, radius:r} = mote
  {side:side, color: color, line: line, a:a} = _.defaults opts, side: 'right', color: null, line: 0, a: window._view.a
  api.text_top __, side, color
  [label_x, label_y] = [a*x, a*(y-r)-line*api.label_height]
  __.fillText txt, label_x, label_y


api.events =
  down: ['mousedown', 'touchstart']
  up: ['mouseup', 'touchend']
  move: ['mousemove', 'touchmove']
api.get_x = (e, i=0) -> e.targetTouches?[i].pageX or e.clientX
api.get_y = (e, i=0) -> e.targetTouches?[i].pageY or e.clientY
api.add_event_listener = (el, event_key, fun) ->
  el.addEventListener event, ((e) ->
    fun e
    e.preventDefault()), no for event in api.events[event_key]


api.distance = (x0, y0, x1, y1) -> Math.sqrt (Math.pow x1-x0, 2)+(Math.pow y1-y0, 2)
