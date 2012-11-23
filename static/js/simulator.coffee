___ = -> console.log arguments...

Arena = window.Arena

###
Rule = 
  init: (seed) -> 'state'
  next: (state, cmds) -> 'state'
###

window.View ?=
  init: (sim) ->
    ___ 'init view'


_aidentity = "return null"


window.Sim = class Sim
  data: []
  constructor: (@rule, @ais) ->
    #___ @rule, @ais
    rule = @rule ?= new Arena((new Date()).getTime())
    ais = @ais ?= [_aidentity, "return 1"]

    states = @states = [@rule.init()]
    cmds = []

    # make worker threads for ais
    workers = for ai in ais
      code = @wrap_ai ai
      #___ code
      blob = new Blob [code]
      URL = window.URL || window.webkitURL;
      blobURL = URL.createObjectURL blob
      worker = new Worker blobURL

      # get result from thread
      ((idx) ->
        worker.addEventListener 'message', (e) ->
          #___ e.data
          cmds[idx] = e.data
          if cmds.length == ais.length and _.all cmds
            # all results are in
            state = rule.next(states[states.length - 1], cmds)
            states.push state
            cmds.length = 0

            # start next round if not finished
            if state
              for worker, i in workers
                worker.postMessage JSON.stringify state
          
        ,false
      )(i)

      # start simulation thread
      worker.postMessage JSON.stringify states[0]
      worker

  wrap_ai: (ai) -> 
    if not new Function(ai)
      ai = ''
    ai = JSON.stringify ai
    """
      ai = Function("state", "me", "postMessage", "self", "XMLHttpRequest", '"use strict";' + #{(ai)})
      
      self.addEventListener('message', function(e){
        var state = e.data.state
        var me = e.data.me
        self.postMessage(JSON.stringify(ai(state, me)))
      })
    """

