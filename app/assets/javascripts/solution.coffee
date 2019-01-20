window.setupSolution = (solutionID, iterationID) ->
  updateStatusDiscussionPost = (content) =>
    if content.length > 0 && $(".new-discussion-post-form .btn-toolbar .saved").length < 1
      $(".new-discussion-post-form .btn-toolbar").append("<span class='saved'>Draft saved</span>")
    if content.length < 1
      $(".new-discussion-post-form .btn-toolbar .saved").remove()

  getLocalStoragePost = =>
    content = localStorage.getItem('discussionPost-' + solutionID + '-' + iterationID) || ""
    updateStatusDiscussionPost(content)
    return content

  setLocalStoragePost = (content) =>
    if content.length > 0
      localStorage.setItem('discussionPost-' + solutionID + '-' + iterationID, content)
    else 
      localStorage.removeItem('discussionPost-' + solutionID + '-' + iterationID)
    updateStatusDiscussionPost(content)

  setupNewDiscussionPost = =>
    $textarea = $(".new-discussion-post-form textarea")
    return if $textarea.length == 0

    $textarea.markdown
      iconlibrary: 'fa'
      hiddenButtons: 'cmdHeading cmdImage cmdPreview'
      resize: 'vertical'

    $textarea.val(getLocalStoragePost())
    $textarea.keyup()

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
  setupTabs()
  setupNewDiscussionPost()
