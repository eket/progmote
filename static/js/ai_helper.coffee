[API, V, M, G] =
  [window._ai_helper = {},
  window._view,
  window._mote,
  window._geom]

API.same = (strain) -> (m) -> m.strain is strain

white = one.color '#fff'
red = 'rgb(255,0,0)'
counter_darken = 'rgba(0,0,0,0.5)'

API.draw_counter = (ctx, mote, prog) ->
  {x:x, y:y, radius:r} = mote
  if prog > 0
    passed_angle = (1-prog)*2*G.pi
    start_angle = -0.5*G.pi
    ctx.fillStyle = counter_darken
    ctx.beginPath()
    ctx.moveTo V.a*x, V.a*y
    ctx.arc V.a*x, V.a*y, V.a*r, start_angle, start_angle+passed_angle, no
    ctx.fill()

API.draw_targets = (ctx, mote, targets) ->
  ctx.lineWidth = 1
  _.each targets, (target, i) ->
    ctx.strokeStyle =
      if i is 0 then red
      else (white.alpha 1-i/targets.length).cssa()
    ctx.beginPath()
    ctx.moveTo V.a*mote.x, V.a*mote.y
    ctx.lineTo V.a*target.x, V.a*target.y
    ctx.stroke()

