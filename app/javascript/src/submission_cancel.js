class SubmissionCancel {
  render() {
    this.container = $(`
      <div class="overlay">
        <div class="submission-cancel-confirmation">
          <div class="submission-cancel-confirmation-content">
            <p class="submission-cancel-confirmation-title">
              Cancel running code
            </p>
            <p class="submission-cancel-confirmation-message">
              Are you sure you want to cancel running this code?
            </p>
            <div class="button-group">
              <button class="submission-cancel-confirmation-confirm-button js-submission-cancel-confirm pure-button">Yes, cancel</button>
              <button class="submission-cancel-confirmation-cancel-button js-submission-cancel-refuse pure-button">Continue waiting</button>
            </div>
          </div>
        </div>
      </div>
    `).appendTo('body');

    this._setupActions();
  }

  _setupActions() {
    this.
      container.
      find('.js-submission-cancel-confirm').
      click(() => { this.container.remove(); this.onConfirm(); });
    this.
      container.
      find('.js-submission-cancel-refuse').
      click(() => { this.container.remove(); this.onRefuse(); });
  }
}

export default SubmissionCancel;
