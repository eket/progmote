codemirror = null
ais =
  help: '/static/js/help.txt'
  full_on: '/static/js/ai_full_on.txt'
  cheater: '/static/js/ai_cheater.txt'
  local_storage: 'local_storage'
strains  = ['select strain'].concat window._strains.list
modes = ['select mode', 'solo', 'live']

set_ai = (key) ->
  Main.ai = key
  update_settings()
  if key is 'local_storage'
    data = window.localStorage?.ai_code
    codemirror.setValue data
  else $.get ais[key], (data) ->
    codemirror.setValue data

set_strain = (strain) ->
  Main.strain = strain
  update_settings()
  if strain isnt strains[0] and (m=Main.mode) isnt modes[0]
    console.log strain
    arena()["_#{m}"].ai_strain = strain

set_mode = (mode) ->
  if mode isnt modes[0]
    arena()._view.set_mode mode
    set_strain strains[_.random 1, strains.length]

arena = -> $('#mote')[0].contentWindow

setup_ai_controls = ->
  if arena()._ai?.Gui?
    ai_obj = arena()._ai.Gui
    ai_ui = GUI.addFolder 'ai parameters'
    _.each ai_obj, (value, key) ->
      ai_ui.add ai_obj, key, value

compile_and_eval = ->
  ai_coffee = codemirror.getValue()
  ai_js = CoffeeScript.compile ai_coffee
  arena().eval ai_js
  console.log ai_js
  arena()._solo.ai_error = null
  if Main.save_on_eval
    console.log 'save'
    window.localStorage?.ai_code = ai_coffee
  setup_datgui()
  console.log 'eval done'

setup_codemirror = ->
  codemirror = CodeMirror $('#codemirror')[0],
    value: ''
    mode: 'coffeescript'
    theme: 'solarized-dark'
    lineNumbers: on
    height: '100%'
    tabSize: 2
    autofocus: on
    lineWrapping: on
    extraKeys:
      'Ctrl-Enter': compile_and_eval

Main = new (->
  @mode = modes[0]
  @ai = ais.help
  @strain = strains[0]
  @step = 2
  @eval = compile_and_eval
  @bg_transparency = 0.5
  @hide_code = no
  @save_on_eval = on
  @opacity = 1)

HUD = new (->
  @speed = on
  @radius_line = 0
  @mass_line = 1
  @time = on)

GUI = null

set_code_bg = (v) ->
  $('.cm-s-solarized-dark,.CodeMirror-gutter').css
    background: "rgba(0,43,54,#{v})"

update_settings = ->
  _.each GUI.__folders['game settings'].__controllers, (c) ->
    c.updateDisplay()

setup_datgui = ->
  GUI = null
  GUI = new dat.GUI autoPlace: false
  $('#datgui').empty().append GUI.domElement

  (game_gui = GUI.addFolder 'game settings').open()
  (game_gui.add Main, 'mode', modes)
    .onChange (mode) -> set_mode mode

  (game_gui.add Main, 'strain', strains)
    .onFinishChange (strain) -> set_strain strain

  (game_gui.add Main, 'ai', _.keys ais)
    .onFinishChange (ai) -> set_ai ai

  game_gui.add Main, 'save_on_eval', on

  code_ui = GUI.addFolder 'code ui'
  (code_ui.add Main, 'bg_transparency', 0, 1).onChange (v) ->
    set_code_bg v

  (code_ui.add Main, 'opacity', 0, 1).onChange (v) ->
    $('#col-code').css opacity: v

  sim_ui = GUI.addFolder 'simulation'

  hud = sim_ui.addFolder 'hud'
  (hud.add HUD, 'speed').onChange (v) ->
    arena()._view?.hud.speed = v
  ((hud.add HUD, 'radius_line', -1, 5).step 1).onChange (v) ->
    arena()._view?.hud.radius = v
  ((hud.add HUD, 'mass_line', -1, 5).step 1).onChange (v) ->
    arena()._view?.hud.mass = v
  (hud.add HUD, 'time').onChange (v) ->
    arena()._view?.hud.time = v

  (sim_ui.add Main, 'step', 0, 5).onChange (exp) ->
    arena()._solo.dt = Math.pow 10, exp-4

  setup_ai_controls()

  (GUI.add Main, 'hide_code').onChange (v) ->
    $('#col-code')[(if v then 'hide' else 'show')]()

  GUI.add Main, 'eval'

$ ->
  setup_codemirror()
  set_code_bg 0.5
  setup_datgui()
  set_ai if window.localStorage?.ai_code? then 'local_storage' else 'help'
