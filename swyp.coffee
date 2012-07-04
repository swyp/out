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
 	window.fileURL = "http://swyp.us/out/filePrompt.jpg"

  window.pickFileButtonPressed = ->
    filepicker.getFile null, {'modal': true, services: [filepicker.SERVICES.IMAGE_SEARCH, filepicker.SERVICES.COMPUTER,filepicker.SERVICES.URL, filepicker.SERVICES.WEBCAM, filepicker.SERVICES.FACEBOOK, filepicker.SERVICES.DROPBOX]}, (url, metadata) ->
      window.updatePromptWithNewFileURL url, metadata.type

  $('#filePreview').live(eventsForDevice[0], (e)->
    imgSrc =  $(this).attr 'src'
    $('#swypframe').show()
    $swypWindow.postMessage {e: 'dragstart', typeGroups:window.typeGroups, img: imgSrc, touches:[e.screenX, e.screenY]}, "*"
  )

  window.updatePromptWithNewFileURL = (fileURL, fileType) ->
    window.fileURL = fileURL
    typeGroup = {contentURL: fileURL, contentMIME: fileType}
    window.typeGroups = [typeGroup]

    previewImageURL = fileURL
    if fileType.substring(0, "image".length) != "image"
      previewImageURL = "http://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Text_document_with_page_number_icon.svg/500px-Text_document_with_page_number_icon.svg.png"
    
    $('#filePreview').attr('src', previewImageURL)
