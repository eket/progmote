___ = -> console.log arguments...


Rule = 
  init: (seed) -> 'state'
  next: (state, cmds) -> 'state'


window.View ?=
  init: (sim) ->


_aidentity = (state, me) -> {}

class Sim
  data: []
  constructor: (@rule, @ais) ->
    ___ @rule, @ais
    rule = @rule ?= Arena
    ais = @ais ?= [_aidentity]

    states = @states = [@rule.init()]

    # make worker thread for ais
    code = @wrap_ais @ais
    ___ code
    blob = new Blob [code]
    URL = window.URL || window.webkitURL;
    blobURL = URL.createObjectURL blob
    worker = new Worker blobURL
    worker.addEventListener 'message', (e) ->
      #___ e.data 
      cmds = e.data
      states.push rule.next(states[states.length - 1], JSON.parse e.data)
      if states[states.length-1]
        worker.postMessage JSON.stringify states[states.length - 1]
    ,false

    worker.postMessage JSON.stringify states[0]

  wrap_ais: (ais) -> 
    ais = "[ #{("function(state, me, postMessage){(#{ai})(state, me)}" for ai in ais).join(',')} ]"
    """
      ais = #{ais}
      onmessage = function(e){
        var state = e.data.state
        var me = e.data.me
        cmds = []
        for(var i=0; i<ais.length; i++) {
          cmds.push(ais[i](state, i))
        }
        self.postMessage(JSON.stringify(cmds))
      }
    """

window.init = () ->
  window.sim = new Sim
  window.view = window.View.init(window.sim)
