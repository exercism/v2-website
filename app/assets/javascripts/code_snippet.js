$('.widget-code-snippet button.copy-button').click(function() {
  $(this).parents('.widget-code-snippet').find('input.download-code').select();
  document.execCommand('copy');
  updateButton(this, 'copied!');
});

const updateButton = function (that, message) {
  const oldText = $(that).text();
  $(that).text(message)
  resetButton(that, oldText);
}

const resetButton = function (that, newMessage) {
  setTimeout(function() {
    $(that).text(newMessage)
  }, 2000);
}
