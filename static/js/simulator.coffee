___ = -> console.log arguments...


Rule = 
  init: (seed) -> 'state'
  next: (state, cmds) -> 'state'


window.View ?=
  init: (sim) ->


_aidentity = "return null"

class Sim
  data: []
  constructor: (@rule, @ais) ->
    #___ @rule, @ais
    rule = @rule ?= Arena
    ais = @ais ?= [_aidentity]

    states = @states = [@rule.init()]

    # make worker threads for ais
    workers = for ai in ais
      code = @wrap_ai ai
      #___ code
      blob = new Blob [code]
      URL = window.URL || window.webkitURL;
      blobURL = URL.createObjectURL blob
      worker = new Worker blobURL
      worker

    cmds = []

    for worker, i in workers
      worker.addEventListener 'message', (e) ->
        #___ e.data
        cmds[i] = e.data
        if cmds.length == ais.length and _.all cmds
          step_done()
      ,false

    step_done = ->
        states.push rule.next(states[states.length - 1], cmds)
        if states[states.length-1]
          for worker, i in workers
            worker.postMessage JSON.stringify states[states.length-1]
          
    for worker in workers
      worker.postMessage JSON.stringify states[0]


  wrap_ai: (ai) -> 
    if not new Function(ai)
      ai = ''
    ai = JSON.stringify ai
    """
      ai = Function("state", "me", "postMessage", "self", '"use strict";' + #{(ai)})
      
      self.addEventListener('message', function(e){
        var state = e.data.state
        var me = e.data.me
        self.postMessage(JSON.stringify(ai(state, me)))
      })
    """

window.init = () ->
  window.sim = new Sim
  window.view = window.View.init(window.sim)
