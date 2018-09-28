disableRemoteButton = (button) ->
  $(document).on 'ajax:send', ->
    button.prop(disabled: true).addClass('disabled')
  $(document).on 'ajax:complete', ->
    button.prop(disabled: false).removeClass('disabled')

$('.pure-button.js-disable-on-click').click ->
  disableRemoteButton(this)

$('form').submit ->
  form = $(this)
  button = form.find('.pure-button')
  if form.attr('data-remote') == 'true'
    disableRemoteButton(button)
  else
    button.prop(disabled: true).addClass('disabled')
