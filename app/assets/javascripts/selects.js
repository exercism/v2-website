/*$('select').selectize({
  create: false
})*/

window.submitOnChange = function($select) {
  $select.change(function() {
    $(this).parents('form').trigger('submit.rails')
  })
}
