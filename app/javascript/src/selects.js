window.submitOnChange = function($select) {
  $select.change(function() {
    Rails.fire($(this).parents('form')[0], 'submit')
  })
}
