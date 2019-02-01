window.closeModal = ->
  $('body').removeClass('with-modal')
  $('#modal-wrapper').hide()
  return false

$('#modal-wrapper').click (e) ->
  $e = $(e.target)

  closeModal() if $e.attr('id') == 'modal-close-button' ||
                  $e.attr('id') == 'modal-close-button-icon' ||
                  $e.hasClass('close-modal') ||
                  $e.data('close-modal') ||
                  (
                    $e.attr('id') == "modal-wrapper" &&
                    $e.find("#modal").hasClass('autoclose')
                  )

$(document).keyup (e) ->
   closeModal() if e.key == "Escape" &&
                $('#modal-wrapper #modal.autoclose:visible').length == 1


window.showModal = (className, html, options = null) ->
  if options
    options = JSON.parse(options)
  else
    options = {}

  $("#modal-wrapper").removeClass()
  $("#modal-wrapper #modal").removeClass().addClass(className)
  $("#modal-wrapper #modal").html(html)

  if options['close_button']
    $("#modal-wrapper #modal").prepend("<div id='modal-close-button'><i id='modal-close-button-icon' class='fa fa-times'></i></div>")
    $("#modal-wrapper #modal").addClass("autoclose") unless options['no_autoclose']

  $("#modal-wrapper").show()
  $('body').addClass('with-modal')

