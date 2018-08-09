window.setupMyTrackMentored = function() {
  $(".core-exercises .unlocked-exercises a.unlocked-exercise").each(function(idx, el){
    var $el = $(el)
    var title = $el.data("title")
    var status = $el.data("status")
    var section = $el.parents(".unlocked-exercises").siblings("h3")
    $el.hover(
      function(){
        section.html("<strong>" + title + "</strong>: " + status)
      },
      function(){
        section.text("You've unlocked extra exercises!")
      })
  });
}
