api = window._ai_helper = {}
view = window._view
_lib = window._view_lib

api.distance = (a, b) -> _lib.distance a.x, a.y, b.x, b.y
api.same = (strain) -> (m) -> m.strain is strain

black = one.color '#000'
white = one.color '#fff'
red = one.color '#f00'
counter_darken = black.alpha 0.2
counter_lighten = white.alpha 0.2

api.draw_counter = (ctx, mote, prog) ->
  {x:x, y:y, radius:r} = mote
  ctx.fillStyle = (if prog > 0 then counter_darken else counter_lighten).cssa()
  ctx.beginPath()
  ctx.moveTo view.a*x, view.a*y

  passed_angle = (1-prog)*2*Math.PI
  start_angle = -0.5*Math.PI
  ctx.arc view.a*x, view.a*y, view.a*r, start_angle, start_angle+passed_angle, no
  ctx.fill()

api.draw_targets = (ctx, mote, targets) ->
  _.each targets, (target, i) ->
    ctx.strokeStyle =
      if i is 0
        red.css()
      else (white.alpha 1-i/targets.length).cssa()
    ctx.beginPath()
    ctx.moveTo view.a*mote.x, view.a*mote.y
    ctx.lineTo view.a*target.x, view.a*target.y
    ctx.stroke()

