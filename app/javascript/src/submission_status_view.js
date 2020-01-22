class SubmissionStatusView {
  constructor(status) {
    this.status = status;
  }

  render() {
    switch(this.status) {
      case 'queueing':
        return `
          <div class="submission-status-queueing">
            <div class="submission-status-spinner">
              <i aria-hidden="true" class="fas fa-spinner fa-spin"></i>
            </div>
            <p class="submission-status-title">Processing</p>
            <p class="submission-status-status">Queueing...</p>
          </div>
            <i class="fa-times fal" />
            ESC to
            <a href="#" title="Cancel" class="js-cancel-submission">cancel</a>
          </div>
        `;
      case 'timeout':
        return `
          <div class="submission-status-timeout">
            <div class="submission-status-spinner">
              <i aria-hidden="true" class="fal fa-ellipsis-h"></i>
            </div>
            <p class="submission-status-title">Taking too long?</p>
            <p class="submission-status-status">
              It looks like you've been waiting a while. Re-run your code and
              we'll boost it to the front of the queue.
            </p>
            <button class="submission-status-button js-submit-code pure-button pure-button-primary">
              Re-run your code
            </button>
          </div>
        `
      case 'cancelling':
        return `
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
        `
    }
  }
}

export default SubmissionStatusView;
