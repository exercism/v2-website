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
    eyesCenterX = 0.5 * ($leftEye.offset().left + $leftEye.width() + $rightEye.offset().left - $honeycomb.offset().left)
    eyesCenterY = $leftEye.offset().top + ($leftEye.height() / 2) - $honeycomb.offset().top

    spaceToLeft = honeycombWidth - (honeycombWidth - eyesCenterX)
    spaceToRight = honeycombWidth - spaceToLeft
    spaceToTop = honeycombHeight - (honeycombHeight - eyesCenterY)
    spaceToBottom = honeycombHeight - spaceToTop

    $honeycomb.mousemove(function(e) {
      mouseX = e.pageX - $honeycomb.offset().left
      mouseToEyesOffsetX = eyesCenterX - mouseX
      if(mouseToEyesOffsetX > 0) {
        // mouse is to the left
        $pupils.css('left', Math.max(5 - (mouseToEyesOffsetX / spaceToLeft * 2), 0))
      } else {
        // mouse is to the right
        $pupils.css('left', Math.min(5 + (-mouseToEyesOffsetX / spaceToRight * 2), 9))
      }

      mouseY = e.pageY - $honeycomb.offset().top
      mouseToEyesOffsetY = eyesCenterY - mouseY
      if(mouseToEyesOffsetY > 0) {
        // mouse is to the top
        $pupils.css('top', Math.max(5 - (mouseToEyesOffsetY / spaceToTop * 2), 0))
      } else {
        // mouse is to the bottom
        $pupils.css('top', Math.min(5 + (-mouseToEyesOffsetY / spaceToBottom * 2), 9))
      }

    })
  }
  setupGopher()
}
