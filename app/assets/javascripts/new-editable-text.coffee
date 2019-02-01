window.setupNewEditableText = (localStorageKey) =>
  updateStatus = (content) =>
    if content.length > 0 && $(".new-editable-text .btn-toolbar .saved").length < 1
      $(".new-editable-text .btn-toolbar").append("<span class='saved'>Draft saved</span>")
    if content.length < 1
      $(".new-editable-text .btn-toolbar .saved").remove()

  getLocalStoragePost = =>
    content = localStorage.getItem(localStorageKey) || ""
    updateStatus(content)
    return content

  setLocalStoragePost = (content) =>
    if content.length > 0
      localStorage.setItem(localStorageKey, content)
    else 
      localStorage.removeItem(localStorageKey)
    updateStatus(content)

  $textarea = $(".new-editable-text textarea")
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
      $('.new-editable-text .preview-area').html(x)
      Prism.highlightAll()

  $(".new-editable-text").on "ajax:success", ->
    $('.new-editable-text textarea').val("")
    $('.new-editable-text .preview-area').html('')
    Prism.highlightAll()
    setLocalStoragePost("")
