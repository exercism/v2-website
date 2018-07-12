var Walkthrough = {
  bindEvents: function() {
    $("a[data-passage]").on("click", function() {
      setTimeout(
        function() {
          Walkthrough.bindEvents();
          $("#modal").animate({ scrollTop: 0 });
        },
        100
      )
    });
  }
}
