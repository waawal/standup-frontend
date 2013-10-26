Spine = require('spine')

class Clock extends Spine.Controller
  className: 'clock'

  constructor: ->
    super    
    Meeting.bind('create refresh change', @render)

  render: =>

  new: ->
    @navigate('/users','create')