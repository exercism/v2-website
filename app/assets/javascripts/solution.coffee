window.setupSolution = ->
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
  $window.scroll =>
    if $window.scrollTop() > $lhs.position().top - 10
      $lhs.addClass('fixed')
    else
      $lhs.removeClass('fixed')

  setupTabs = =>
    $('.tab').click ->
      $container = $(this).closest('.tabs-and-panes')
      console.log $container

      for c in $container[0].className.split(" ")
        $container.removeClass(c) if c.startsWith("selected-")

      tabId = null
      for c in this.className.split(" ")
        tabId = c.replace("tab-", "") if c.startsWith("tab-")

      $container.addClass("selected-\#{tabId}") if tabId

  setupNewDiscussionPost = =>
    $textarea = $(".new-discussion-post-form textarea")
    smde = new SimpleMDE
      element: $textarea[0]
      spellChecker: false
      forceSync: true
      status: false
      toolbar: ["bold", "italic", "strikethrough", "|", "quote", "code", "link", "|", "unordered-list", "ordered-list"]

    $('.preview-tab').click ->
      markdown = $textarea.val()
      $.post "/markdown/parse", {markdown: markdown}, (x,y,z) =>
        console.log x,y,z
        $('.new-discussion-post-form .preview-area').html(x)
        Prism.highlightAll()

    $('.CodeMirror').bind 'heightChange', =>
      $('.preview-area').css(height: $('.CodeMirror').outerHeight())

  $window.resize setupLayout
  setupLayout()
  setupTabs()
  setupNewDiscussionPost()
