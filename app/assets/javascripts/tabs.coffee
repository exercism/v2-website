window.setupTabs = ->
  $('.tab').click ->
    $container = $(this).closest('.tabs-and-panes')

    for c in $container[0].className.split(" ")
      $container.removeClass(c) if c.startsWith("selected-")

    tabId = null
    for c in this.className.split(" ")
      tabId = c.replace("tab-", "") if c.startsWith("tab-")

    $container.addClass("selected-#{tabId}") if tabId
