$('.pure-button.js-disable-on-click').click ->
  setTimeout (-> $(this).prop(disabled: true).addClass('disabled')), 20
