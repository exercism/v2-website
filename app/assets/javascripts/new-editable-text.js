function setupNewEditableText(localStorageKey) {
  function updateStatus(content) {
    if ((content.length > 0) && ($(".new-editable-text .btn-toolbar .saved").length < 1)) {
      $(".new-editable-text .btn-toolbar").append("<span class='saved'>Draft saved</span>");
    }
    if (content.length < 1) {
      $(".new-editable-text .btn-toolbar .saved").remove();
    }
  }

  function getLocalStoragePost() {
    var content = localStorage.getItem(localStorageKey) || "";
    updateStatus(content);

    return content;
  }

  function setLocalStoragePost(content) {
    if (content.length > 0) {
      localStorage.setItem(localStorageKey, content);
    } else {
      localStorage.removeItem(localStorageKey);
    }
    updateStatus(content);

    return content;
  }

  var $textarea = $(".new-editable-text textarea");
  if ($textarea.length === 0) { return; }

  $textarea.markdown({
    iconlibrary: 'fa',
    hiddenButtons: 'cmdHeading cmdImage cmdPreview',
    resize: 'vertical'
  });

  $textarea.val(getLocalStoragePost());
  $textarea.keyup();

  $textarea.bind("keyup change input", function() {
    setLocalStoragePost($textarea.val());
  });

  $('.preview-tab').click(function() {
    var markdown = $textarea.val();
    $.post("/markdown/parse", {markdown: markdown}, function (x,y,z) {
      $('.new-editable-text .preview-area').html(x);
      Prism.highlightAll();
    });
  });

  $(".new-editable-text").on("ajax:success", function() {
    $('.new-editable-text textarea').val("");
    $('.new-editable-text .preview-area').html('');
    Prism.highlightAll();
    setLocalStoragePost("");
  });
}

