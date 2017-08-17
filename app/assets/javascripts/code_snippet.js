$('.widget-code-snippet button.copy-button').click(function() {
  $(this).parents('.widget-code-snippet').find('input.download-code').select();
  document.execCommand('copy');
})
