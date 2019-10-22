var ImagePreview = {
  bindEvents: function() {
    $('.js-image-preview-file').change(function() {
      var input = this;

      if (input.files) {
        var reader = new FileReader();

        reader.onload = function(e) {
          $('.js-image-preview-container').css(
            'background-image',
            'url("' + e.target.result + '")'
          );
        }

        reader.readAsDataURL(input.files[0]);
      }
    });
  }
};

window.ImagePreview = ImagePreview;
