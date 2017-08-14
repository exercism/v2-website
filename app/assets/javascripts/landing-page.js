window.setupLandingPage = function() {
  $.fn.animateBgPosition = function( y, speed ) {
    var pos = this.css( "background-position" ).split( " " );
    this.y = parseInt( pos[1], 10 ) || 0;
    $.Animation( this, {
        y: y
      }, { duration: speed, easing: 'linear' }).
      progress( function( e ) {
        this.css( "background-position", "0px " + e.tweens[0].now + "px" );
      })

    return this;
  };
  $('.step-4 .waterfall').animateBgPosition( 50000, 1500000 )

  setupGopher = function() {
    $leftEye = $('.go .left-eye')
    $rightEye = $('.go .right-eye')
    $pupils = $('.go .pupil')
    $honeycomb = $('.tracks-section .tracks')

    honeycombHeight = $honeycomb.height()
    honeycombWidth = $honeycomb.width()
    eyesCenterX = $leftEye.offset().left - $honeycomb.offset().left + 15
    eyesCenterY = $leftEye.offset().top - $honeycomb.offset().top + 5

    spaceToLeft = honeycombWidth - (honeycombWidth - eyesCenterX)
    spaceToRight = honeycombWidth - spaceToLeft
    spaceToTop = honeycombHeight - (honeycombHeight - eyesCenterY)
    spaceToBottom = honeycombHeight - spaceToTop

    $honeycomb.mousemove(function(e) {
      mouseX = e.pageX - $honeycomb.offset().left
      mouseToEyesOffsetX = eyesCenterX - mouseX
      if(mouseToEyesOffsetX > 0) {
        // mouse is to the left
        $pupils.css('left', 5 - (mouseToEyesOffsetX / spaceToLeft * 5))
      } else {
        // mouse is to the right
        $pupils.css('left', 5 + (-mouseToEyesOffsetX / spaceToRight * 5))
      }

      mouseY = e.pageY - $honeycomb.offset().top
      mouseToEyesOffsetY = eyesCenterY - mouseY
      if(mouseToEyesOffsetY > 0) {
        // mouse is to the left
        $pupils.css('top', 5 - (mouseToEyesOffsetY / spaceToTop * 5))
      } else {
        // mouse is to the right
        $pupils.css('top', 5 + (-mouseToEyesOffsetY / spaceToBottom * 5))
      }

    })
  }
  setupGopher()
}
