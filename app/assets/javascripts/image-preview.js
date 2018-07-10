var ImagePreview = {
  bindEvents: function() {
    $('.js-image-preview-file').change(function() {
      var input = this;

      if (input.files) {
        var reader = new FileReader();

        reader.onload = function(e) {
          $('.js-image-preview-container').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
      }
    });
  }
};
