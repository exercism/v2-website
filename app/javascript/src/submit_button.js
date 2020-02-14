class SubmitButton {
  constructor(element) {
    this.element = element;
  }

  waitingForSubmission() {
    this.element.attr('disabled', false);
  }

  submitted() {
    this.element.attr('disabled', true);
  }

  click(handler) {
    this.element.click(handler);
  }
}

export default SubmitButton;
