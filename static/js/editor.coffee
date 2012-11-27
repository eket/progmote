codemirror = null
ais =
  help: '/static/js/help.txt'
  full_on: '/static/js/ai_full_on.txt'
  cheater: '/static/js/ai_cheater.txt'

load_ai = (key) -> $.get ais[key], (data) -> codemirror.setValue data
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
  @mode = ''
  @ai = ''
  @strain = ''
  @step = 2
  @eval = compile_and_eval
  @bg_transparency = 0.5
  @hide_code = no
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

setup_datgui = ->
  GUI = null
  GUI = new dat.GUI autoPlace: false
  $('#datgui').empty().append GUI.domElement

  (game_gui = GUI.addFolder 'game settings').open()
  (game_gui.add Main, 'mode', ['select mode', 'solo', 'live'])
    .onChange (mode) ->
      switch mode
        when 'solo' then arena()._view.set_mode 'solo'
        when 'live' then arena()._view.set_mode 'live'

  (game_gui.add Main, 'strain', [null].concat window._strains.list)
    .onChange (strain) ->
      console.log strain
      arena()._solo.ai_strain = strain
      arena()._live_view.ai_strain = strain

  (game_gui.add Main, 'ai', _.keys ais)
    .onChange (ai) -> load_ai ai

  code_ui = GUI.addFolder 'code ui'
  (code_ui.add Main, 'bg_transparency', 0, 1).onChange (v) ->
    set_code_bg v

  (code_ui.add Main, 'opacity', 0, 1).onChange (v) ->
    $('#col-code').css opacity: v

  (code_ui.add Main, 'hide_code').onChange (v) ->
    $('#col-code')[(if v then 'hide' else 'show')]()

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

  GUI.add Main, 'eval'

$ ->
  setup_codemirror()
  set_code_bg 0.5
  setup_datgui()
  load_ai 'help'
