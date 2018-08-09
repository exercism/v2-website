window.setupMyTrackMentored = function() {
  $(".core-exercises .unlocked-exercises a.unlocked-exercise").each(function(idx, el){
    const $el = $(el)
    const title = $el.data("title")
    const status = $el.data("status")
    const section = $el.parents(".unlocked-exercises").siblings("h3")
    $el.hover(
      function(){
        section.html("<strong>" + title + "</strong>: " + status)
      },
      function(){
        section.text("You've unlocked extra exercises!")
      })
  });
}
