window.setupBlogPost = (blogcommentId) ->
  updateStatusblogcomment = (content) =>
    if content.length > 0 && $(".new-blog-comment-form .btn-toolbar .saved").length < 1
      $(".new-blog-comment-form .btn-toolbar").append("<span class='saved'>Draft saved</span>")
    if content.length < 1
      $(".new-blog-comment-form .btn-toolbar .saved").remove()

  getLocalStoragecomment = =>
    content = localStorage.getItem('blogcomment-' + blogcommentId) || ""
    updateStatusblogcomment(content)
    return content

  setLocalStoragecomment = (content) =>
    if content.length > 0
      localStorage.setItem('blogcomment-' + blogcommentId, content)
    else 
      localStorage.removeItem('blogcomment-' + blogcommentId)
    updateStatusblogcomment(content)

  setupNewComment = =>
    $textarea = $(".new-blog-comment-form textarea")
    return if $textarea.length == 0

    $textarea.markdown
      iconlibrary: 'fa'
      hiddenButtons: 'cmdHeading cmdImage cmdPreview'

    $textarea.val(getLocalStoragecomment())
    $textarea.keyup()

    $textarea.bind "keyup change input", ->
      setLocalStoragecomment($textarea.val())

    $('.preview-tab').click ->
      markdown = $textarea.val()
      $.post "/markdown/parse", {markdown: markdown}, (x,y,z) =>
        $('.new-blog-comment-form .preview-area').html(x)
        Prism.highlightAll()

    $(".new-blog-comment-form").on "ajax:success", ->
      $('.new-blog-comment-form textarea').val("")
      $('.new-blog-comment-form .preview-area').html('')
      Prism.highlightAll()
      setLocalStoragecomment("")

  setupTabs()
  setupNewComment()
