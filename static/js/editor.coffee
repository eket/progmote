codemirror = null
ais =
  help: '/static/js/help.txt'
  full_on: '/static/js/ai_full_on.txt'
  cheater: '/static/js/ai_cheater.txt'

load_ai = (key) -> $.get ais[key], (data) -> codemirror.setValue data
arena = -> $('#mote')[0].contentWindow

compile_and_eval = ->
  ai_coffee = codemirror.getValue()
  ai_js = CoffeeScript.compile ai_coffee
  arena().eval ai_js
  console.log ai_js

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
  @mode = ''
  @ai = ''
  @strain = ''
  @step = 2
  @eval = compile_and_eval
  @bg_transparency = 0.5
  @hide_code = no
  @opacity = 1

set_code_bg = (v) ->
  $('.cm-s-solarized-dark,.CodeMirror-gutter').css
    background: "rgba(0,43,54,#{v})"

setup_datgui = ->
  gui = new dat.GUI autoPlace: false
  obj = new GUI()
  $('#datgui').append gui.domElement

  (gui.add obj, 'mode', ['select mode', 'solo', 'live']).onChange (mode) ->
    switch mode
      when 'solo' then arena()._view.set_mode 'solo'
      when 'live' then arena()._view.set_mode 'live'

  (gui.add obj, 'strain', [null].concat window._strains.list).onChange (strain) ->
    console.log strain
    arena()._solo.ai_strain = strain
    arena()._live_view.ai_strain = strain

  (gui.add obj, 'ai', _.keys ais).onChange (ai) -> load_ai ai

  (gui.add obj, 'step', 0, 5).onChange (exp) ->
    arena()._solo.dt = Math.pow 10, exp-4

  (gui.add obj, 'bg_transparency', 0, 1).onChange (v) ->
    set_code_bg v

  (gui.add obj, 'opacity', 0, 1).onChange (v) ->
    $('#col-code').css opacity: v

  (gui.add obj, 'hide_code').onChange (v) ->
    $('#col-code')[(if v then 'hide' else 'show')]()

  gui.add obj, 'eval'

$ ->
  setup_codemirror()
  set_code_bg 0.5
  setup_datgui()
  load_ai 'help'
