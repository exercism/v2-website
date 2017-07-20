window.closeModal = ->
  $('#modal-wrapper').hide()
  return false

$('#modal-wrapper').click (e) ->
  $e = $(e.target)

  closeModal() if $e.attr('id') == 'modal-close-button' ||
                  $e.attr('id') == 'modal-close-button-icon' ||
                  $e.hasClass('close-modal')
                  $e.data('close-modal')

  closeModal() if $e.attr('id') == "modal-wrapper" &&
                  $e.hasClass('autoclose')


window.showModal = (className, html, options = {}) ->
  $("#modal-wrapper").removeClass()
  $("#modal-wrapper").addClass("no-autoclose") if options['no_autoclose']
  $("#modal-wrapper #modal").removeClass().addClass(className)
  $("#modal-wrapper #modal").html(html)
  $("#modal-wrapper #modal").prepend("<div id='modal-close-button'><i id='modal-close-button-icon' class='fa fa-times'></i></div>") if options['close_button']
  $("#modal-wrapper").show()

