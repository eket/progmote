codemirror = null
ais =
  full_on: '/static/js/ai_full_on.txt'
  cheater: '/static/js/ai_cheater.txt'

load_ai = (key) -> $.get ais[key], (data) -> codemirror.setValue data
arena = -> $('#mote iframe')[0].contentWindow

compile_and_eval = ->
  ai_coffee = codemirror.getValue()
  ai_js = CoffeeScript.compile ai_coffee
  arena().eval ai_js
  console.log ai_js

populate_strains = ->
  strains_dropdown = $('#strains-dropdown')
  _.map window._strains.list, (strain) ->
    strains_dropdown.append $("<li><a href='#'>#{strain}</a></li>").click ->
      console.log strain
      arena()._solo.ai_strain = strain
      arena()._live_view.ai_strain = strain

set_handlers = ->
  $('#ai-full_on').click -> load_ai 'full_on'
  $('#ai-cheater').click -> load_ai 'cheater'

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

$ ->
  populate_strains()
  setup_codemirror()
  set_handlers()
  #arena()._view.set_mode 'live'
  load_ai 'full_on'

obj =
  message: 'dat.gui';
  speed: 0.8
  displayOutline: false;
  explode: console.log

###
$ ->
  gui = new dat.GUI autoPlace: false
  $('.gui .mote').append gui.domElement
  _add = (a, b, c)-> gui.add view_options, a, b, c
  _add 'delay', 0.01, 1

  gui = new dat.GUI autoPlace: false
  $('.gui .code').append gui.domElement
  gui.add obj, 'message'
  gui.add obj, 'speed', -5, 5
  gui.add obj, 'displayOutline'
  gui.add obj, 'explode'
###
