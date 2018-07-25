window.setupSolutionTabs = ->
    $('.tab').click ->
      $container = $(this).closest('.tabs-and-panes')

      for c in $container[0].className.split(" ")
        $container.removeClass(c) if c.startsWith("selected-")

      tabId = null
      for c in this.className.split(" ")
        tabId = c.replace("tab-", "") if c.startsWith("tab-")

      $container.addClass("selected-#{tabId}") if tabId
window.setupSolution = ->
  ###
    $window = $(window)
    setupLayout = =>
      $lhs = $('.lhs')
      $rhs = $('.rhs')
      $lhs_content = $('.lhs-content')
      $lhs_content.css
        left: $lhs.position().left
        width: $lhs.outerWidth()
      $rhs.css
        minHeight: $window.height()

    $lhs = $('.lhs')
    $notificationsBar = $('.notifications-bar')
    $window.scroll =>
      console.log($window.scrollTop())
      console.log($notificationsBar.position().top)
      if $window.scrollTop() >= 300 #$notificationsBar.position().top - 10
        $lhs.addClass('fixed')
      else
        $lhs.removeClass('fixed')
  ###

  setupNewDiscussionPost = =>
    $textarea = $(".new-discussion-post-form textarea")
    return if $textarea.length == 0
    smde = new SimpleMDE
      element: $textarea[0]
      spellChecker: false
      forceSync: true
      status: false
      toolbar: ["bold", "italic", "strikethrough", "|", "quote", "code", "link", "|", "unordered-list", "ordered-list"]

    $('.preview-tab').click ->
      markdown = $textarea.val()
      $.post "/markdown/parse", {markdown: markdown}, (x,y,z) =>
        $('.new-discussion-post-form .preview-area').html(x)
        Prism.highlightAll()

    $('.CodeMirror').bind 'heightChange', =>
      $('.preview-area').css(height: $('.CodeMirror').outerHeight())

  #$window.resize(setupLayout)
  #setupLayout()
  setupSolutionTabs()
  setupNewDiscussionPost()
