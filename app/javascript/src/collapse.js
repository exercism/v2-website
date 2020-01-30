class Collapse {
  constructor(element) {
    this.element = element;
    this.trigger = element.find('.js-collapse-trigger');

    this.trigger.on('click', this.toggle.bind(this));

    if (!this.isOpen() && !this.isClosed()) { this.collapse(); }
  }

  toggle() {
    if (this.isOpen()) {
      this.collapse();
    } else {
      this.open();
    }
  }

  open() {
    this.element.removeClass('closed').addClass('open');

  }
  collapse() {
    this.element.removeClass('open').addClass('closed');
  }

  isOpen() {
    return this.element.hasClass('open');
  }

  isClosed() {
    return this.element.hasClass('closed');
  }
}

export default Collapse;
