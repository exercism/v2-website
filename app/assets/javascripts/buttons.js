function disableRemoteButton(button) {
  $(document).on('ajax:send', function() {
    button.prop({disabled: true}).addClass('disabled')
  });
  $(document).on('ajax:complete', function() {
    button.prop({disabled: false}).removeClass('disabled')
  });
}

$('.pure-button.js-disable-on-click').click(function() {
  disableRemoteButton($(this));
});

$('form').submit(function() {
  var form = $(this);
  var button = form.find('.pure-button');
  if (form.attr('data-remote') === 'true') {
    disableRemoteButton(button);
  } else {
    button.prop({disabled: true}).addClass('disabled');
  }
});
