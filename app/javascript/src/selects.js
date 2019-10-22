window.submitOnChange = function($select) {
  $select.change(function() {
    var form = $(this).parents('form');
    var isRemote = $(form).data("remote");

    if (isRemote) {
      Rails.fire(form[0], 'submit');
    } else {
      form[0].submit();
    }
  })
}
