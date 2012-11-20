console.log 'hellop'

myCodeMirror = CodeMirror $('#codemirror')[0], 
  value: "ai = (me, motes, controls, state) ->\n  if !controls controls =\n    mode: 'agressive'\n  return 0\n"
  mode: "coffeescript"
  theme: "solarized-dark"
  height: "100%"
  tabSize: 2
  autofocus: on

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
