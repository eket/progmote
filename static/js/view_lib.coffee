window.___ = (x) -> console.log x
[API, M, G, O] =
  [window._view_helper = {},
  window._mote,
  window._geom,
  window.one]

# clear context
API.clr = (ctx, w, h=w) -> ctx.clearRect 0, 0, w, h

# hud label height
API.label_height = 20

# some colors
API.white = O.color '#fff'

# set basic text properties
API.set_text = (ctx, color=API.white) ->
  ctx.font = "normal #{API.label_height}px monospace"
  ctx.fillStyle = color.cssa()

# set more text properties
API.set_text_over_point = (ctx, side, color) ->
  API.set_text ctx, (color ? (O.color ctx.fillStyle).alpha 0.2)
  ctx.textBaseline = 'bottom'
  ctx.textAlign = side

# annotate a mote with text
# uses window._view
API.annotate = (ctx, mote, txt, opts={}) ->
  {x:x, y:y, radius:r} = mote
  {side:side, color: color, line: line, a:a} =
    _.defaults opts, side: 'right', color: null, line: 0, a: window._view.a
  API.set_text_over_point ctx, side, color
  [label_x, label_y] = [a*x, a*(y-r)-line*API.label_height]
  ctx.fillText txt, label_x, label_y

# easy event handling
API.events =
  down: ['mousedown', 'touchstart']
  up: ['mouseup', 'touchend']
  move: ['mousemove', 'touchmove']
API.get_x = (e, i=0) -> e.targetTouches?[i].pageX or e.clientX
API.get_y = (e, i=0) -> e.targetTouches?[i].pageY or e.clientY
API.add_event_listener = (el, event_key, fun) ->
  el.addEventListener event, ((e) ->
    fun e
    e.preventDefault()), no for event in API.events[event_key]
