function setupTabs() {
  $('.tab').click(function() {
    var $container = $(this).closest('.tabs-and-panes');
    var i;
    var c;
    var len;

    for (i = 0, len = $container[0].className.split(" ").length; i < len; i++) {
      c = $container[0].className.split(" ")[i]

      if (c.startsWith("selected-")) { $container.removeClass(c); }
    }

    var tabId = null;

    for (i = 0, len = this.className.split(" ").length; i < len; i++) {
      c = this.className.split(" ")[i]

      if (c.startsWith("tab-")) { tabId = c.replace("tab-", ""); }
    }

    if (tabId) { $container.addClass('selected-' + tabId); }
  });
}
