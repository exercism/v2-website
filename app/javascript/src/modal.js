function closeModal() {
  $('body').removeClass('with-modal');
  $('#modal-wrapper').hide();

  return false;
}

$('#modal-wrapper').click(function(e) {
  var $e = $(e.target);

  if (($e.attr('id') === 'modal-close-button') ||
                  ($e.attr('id') === 'modal-close-button-icon') ||
                  $e.hasClass('close-modal') ||
                  $e.data('close-modal') ||
                  (
                    ($e.attr('id') === "modal-wrapper") &&
                    $e.find("#modal").hasClass('autoclose')
                  )) { closeModal(); }
});

$(document).keyup(function(e) {
   if ((e.key === "Escape") &&
                ($('#modal-wrapper #modal.autoclose:visible').length === 1)) { closeModal(); }
});


function showModal(className, html, options) {
  if (options) {
    options = JSON.parse(options);
  } else {
    options = {};
  }

  $("#modal-wrapper").removeClass();
  $("#modal-wrapper #modal").removeClass().addClass(className);
  $("#modal-wrapper #modal").html(html);

  if (options['close_button']) {
    $("#modal-wrapper #modal").prepend("<div id='modal-close-button'><i id='modal-close-button-icon' class='fa fa-times'></i></div>");
    if (!options['no_autoclose']) { $("#modal-wrapper #modal").addClass("autoclose"); }
  }

  $("#modal-wrapper").show();
  $('body').addClass('with-modal');
}

window.closeModal = closeModal;
window.showModal = showModal;
