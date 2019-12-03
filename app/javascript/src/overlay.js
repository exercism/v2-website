class Overlay {
  show(html) {
    this.getOverlay().html(html);
    this._setupActions();
  }

  getOverlay() {
    if ($('.overlay').length == 0) {
      return $('<div class="overlay" />').appendTo('body');
    } else {
      return $('.overlay');
    }
  }

  close() {
    this.getOverlay().remove();
  }

  _setupActions() {
    $('.js-overlay-close').click(this.close.bind(this));
  }
}

export default Overlay;
