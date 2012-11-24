codemirror = null
ais =
  help: '/static/js/help.txt'
  full_on: '/static/js/ai_full_on.txt'
  cheater: '/static/js/ai_cheater.txt'

load_ai = (key) -> $.get ais[key], (data) -> codemirror.setValue data
arena = -> $('#mote iframe')[0].contentWindow

compile_and_eval = ->
  ai_coffee = codemirror.getValue()
  ai_js = CoffeeScript.compile ai_coffee
  arena().eval ai_js
  console.log ai_js

set_handlers = ->
  $('#mode-solo').click -> arena()._view.set_mode 'solo'
  $('#mode-live').click -> arena()._view.set_mode 'live'
  $('.run.btn').click -> compile_and_eval()

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

GUI = ->
  @ai = 'ai'
  @strain = 'strain'
  @step = 2
  @

setup_datgui = ->
  gui = new dat.GUI autoPlace: false
  obj = new GUI()
  $('.gui .code').append gui.domElement

  (gui.add obj, 'ai', _.keys ais).onFinishChange (ai) -> load_ai ai

  (gui.add obj, 'strain', window._strains.list).onFinishChange (strain) ->
    console.log strain
    arena()._solo.ai_strain = strain
    arena()._live_view.ai_strain = strain

  (gui.add obj, 'step', 0, 5).onChange (exp) ->
    arena()._solo.dt = Math.pow 10, exp-4

$ ->
  setup_codemirror()
  set_handlers()
  setup_datgui()
  load_ai 'help'
