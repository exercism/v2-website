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
  updateStatusDiscussionPost = (content) =>
    if content.length > 0 && $(".new-discussion-post-form .btn-toolbar .saved").length < 1
      $(".new-discussion-post-form .btn-toolbar").append("<span class='saved'>Draft saved</span>")
    if content.length < 1
      $(".new-discussion-post-form .btn-toolbar .saved").remove()

  getLocalStoragePost = =>
    content = localStorage.getItem('discussionPost-' + window.location.pathname)
    updateStatusDiscussionPost(content)
    return content

  setLocalStoragePost = (content) =>
    localStorage.setItem('discussionPost-' + window.location.pathname, content)
    updateStatusDiscussionPost(content)
    return content

  setupNewDiscussionPost = =>
    $textarea = $(".new-discussion-post-form textarea")
    return if $textarea.length == 0

    $textarea.markdown
      iconlibrary: 'fa'
      hiddenButtons: 'cmdHeading cmdImage cmdPreview'

    $textarea.val(getLocalStoragePost())

    $textarea.bind "keyup change input", ->
      setLocalStoragePost($textarea.val())

    $('.preview-tab').click ->
      markdown = $textarea.val()
      $.post "/markdown/parse", {markdown: markdown}, (x,y,z) =>
        $('.new-discussion-post-form .preview-area').html(x)
        Prism.highlightAll()

    $(".new-discussion-post-form").on "ajax:success", ->
      $('.new-discussion-post-form textarea').val("")
      $('.new-discussion-post-form .preview-area').html('')
      Prism.highlightAll()
      setLocalStoragePost("")

  #$window.resize(setupLayout)
  #setupLayout()
  setupSolutionTabs()
  setupNewDiscussionPost()
