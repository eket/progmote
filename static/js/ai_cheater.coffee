[API, AIH, V, VH, G] =
  [window._ai = {},
  window._ai_helper
  window._view,
  window._view_helper,
  window._geom]

queue = null

init_done = no
init = (ctx) ->
  VH.add_event_listener ctx.canvas, 'down', (e) ->
    queue = [(VH.get_x e)/V.a, (VH.get_y e)/V.a]
  init_done = yes

sames = null
API.doit = (ctx, motes, now, strain) ->
  init ctx unless init_done
  sames = _.filter motes, AIH.same strain
  others = _.reject motes, AIH.same strain

  move =
  if others.length is 0 then 'done'
  else
    select = sames.indexOf _.last _.sortBy sames, 'radius'
    _.map sames, (mote, i) ->
      if i is select and queue?
        [qx, qy] = queue
        a = 2*G.pi + Math.atan2 qy-mote.y, qx-mote.x
        queue = null
        a
      else
        null
  move
