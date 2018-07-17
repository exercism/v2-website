var Walkthrough = {
  bindEvents: function(parent) {
    $("a[data-passage]").on("click", function() {
      setTimeout(
        function() {
          Walkthrough.bindEvents(parent);
          $(parent).animate({ scrollTop: 0 });
        },
        100
      )
    });
  }
}
