$('.widget-code-snippet button.copy-button').click(function() {
  var updateButton = function (btn, message) {
    var oldText = $(btn).text();
    $(btn).text(message).addClass('copied')
    setTimeout(function() {
      resetButton(btn, oldText);
    }, 2000);
  }

  var resetButton = function (btn, newMessage) {
    $(btn).text(newMessage).removeClass('copied')
  }

  $(this).parents('.widget-code-snippet').find('input.download-code').select();
  document.execCommand('copy');
  updateButton(this, 'copied!');
});
