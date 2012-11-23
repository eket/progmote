myCodeMirror = null

ais =
  full_on: '/static/js/ai_full_on.txt'
  cheater: '/static/js/ai_cheater.txt'

arena = -> $('#mote iframe')[0].contentWindow
load_ai = (key) -> $.get ais[key], (data) -> myCodeMirror.setValue data

compile_and_eval = ->
    cs = myCodeMirror.getValue()
    js = CoffeeScript.compile(cs)
    arena().eval(js)
    console.log js

$ ->
  myCodeMirror = CodeMirror $('#codemirror')[0],
    value: ''
    mode: "coffeescript"
    theme: "solarized-dark"
    lineNumbers: on
    height: "100%"
    tabSize: 2
    autofocus: on
    lineWrapping: on
    extraKeys:
      'Ctrl-Enter': compile_and_eval

  load_ai 'full_on'

  strains_dropdown = $('#strains-dropdown')
  _.map window._strains.list, (strain) ->
    strains_dropdown.append $("<li><a href='#'>#{strain}</a></li>").click ->
      console.log strain
      arena()._solo.ai_strain = strain
  $('#ai-full_on').click -> load_ai 'full_on'
  $('#ai-cheater').click -> load_ai 'cheater'
  $('.run.btn').click -> compile_and_eval()

obj =
  message: 'dat.gui';
  speed: 0.8
  displayOutline: false;
  explode: console.log

view_options = 
  delay: 0.1

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
