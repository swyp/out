(function() {
  var eventsForDevice, isTouchDevice, mouseEvents, receiveMessage, testing, touchEvents;

  testing = false;

  isTouchDevice = "ontouchstart" in document.documentElement;

  touchEvents = ["touchstart", "touchmove", "touchend"];

  mouseEvents = ["mousedown", "mousemove", "mouseup"];

  eventsForDevice = (isTouchDevice ? touchEvents : mouseEvents);

  receiveMessage = function(e) {
    var message;
    message = e.data;
    if (message === "HIDE_SWYP") return $('#swypframe').hide();
  };

  $(function() {
    var $stylesheet, $swypWindow, $swypframe;
    window.addEventListener("message", receiveMessage, false);
    $stylesheet = $('<link/>').attr('rel', 'stylesheet').attr('type', 'text/css').attr('href', 'swyp.css');
    $('head').append($stylesheet);
    $swypframe = $('<iframe/>').attr('id', 'swypframe').attr('scrolling', 'no').attr('src', testing ? 'http://127.0.0.1:3000' : 'https://swypserver.herokuapp.com');
    $('body').append($swypframe);
    $swypWindow = $('#swypframe')[0].contentWindow;
    $swypWindow.postMessage({
      e: 'ready'
    });
    /*your specific implementation!
    */
    return $('#filePrompt').live(eventsForDevice[0], function(e) {
      var imgSrc;
      imgSrc = $(this).attr('src');
      $('#swypframe').show();
      return $swypWindow.postMessage({
        e: 'dragstart',
        img: imgSrc,
        touches: [e.screenX, e.screenY]
      }, "*");
    });
  });

}).call(this);
