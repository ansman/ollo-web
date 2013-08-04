class View.Spinner extends Lib.View
  className: 'spinner'
  initialize: ->
    @spinner = new window.Spinner(@options)
    _.defaults(@options, delay: 500)
    @height = @options.height
    @target = @options.target
    @delay = @options.delay
    @spinner = new window.Spinner
      lines: 12
      length: 9
      width: 4
      radius: 14
      color: '#333'
      speed: 1
      trail: 70
      shadow: false
      className: ''
      zIndex: 1

  render: ->
    @spinner.spin()
    @$el.height(@height) if @height
    $(@spinner.el).css
      position: 'absolute'
      left: '50%'
      top: '50%'

    @$el
      .html($(@spinner.el).hide().delay(@delay).fadeIn(500))
      .appendTo(@target)

    this

  onClose: -> @spinner.stop()
