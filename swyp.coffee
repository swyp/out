testing = false # set to true when testing locally
isTouchDevice = "ontouchstart" of document.documentElement
touchEvents = [ "touchstart", "touchmove", "touchend" ]
mouseEvents = [ "mousedown", "mousemove", "mouseup" ]
eventsForDevice = (if isTouchDevice then touchEvents else mouseEvents)

#event has data, origin, and source properties (source = the sender window)
receiveMessage = (e)->
  message = e.data
  if message is "HIDE_SWYP"
    $('#swypframe').hide()

$ ->
  window.addEventListener "message", receiveMessage, false

  # dynamically load the swyp stylesheet
  $stylesheet = $('<link/>').attr('rel', 'stylesheet')
                            .attr('type', 'text/css')
                            .attr('href', 'swyp.css')

  $('head').append $stylesheet

  $swypframe = $('<iframe/>').attr('id', 'swypframe')
                             .attr('scrolling', 'no')
                             .attr('src', if testing then 'http://127.0.0.1:3000' else 'https://swypserver.herokuapp.com')

  $('body').append $swypframe

  $swypWindow = $('#swypframe')[0].contentWindow
  
  ###your specific implementation!###
  
  $('#filePrompt').live(eventsForDevice[0], (e)->
    imgSrc =  $(this).attr 'src'
    $('#swypframe').show()
    # message, targetOrigin: 
    # change targetOrigin to the real swyp server url in production
    $swypWindow.postMessage {e: 'dragstart', img: imgSrc, touches:[e.screenX, e.screenY]}, "*"
  )
