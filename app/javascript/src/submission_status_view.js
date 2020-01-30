class SubmissionStatusView {
  constructor(status) {
    this.status = status;
  }

  render() {
    switch(this.status) {
      case 'queueing':
        return `
          <div class="submission-status queueing">
            <div class="submission-status-spinner">
              <i aria-hidden="true" class="fas fa-spinner fa-spin"></i>
            </div>
            <p class="submission-status-title">Processing</p>
            <p class="submission-status-status">Queueing...</p>

            <a href="#" title="Cancel build" class="js-cancel-submission pure-button cancel-btn">Cancel build</a>
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
            <p class="submission-status-title">Cancel running code</p>
            <p class="submission-status-status">
              Are you sure you want to cancel running this code?
            </p>
            <div class="button-group">
              <button class="confirm-btn js-submission-cancel-confirm pure-button">Yes, cancel</button>
              <button class="cancel-btn js-submission-cancel-refuse pure-button">Continue waiting</button>
            </div>
          </div>
        `
    }
  }
}

export default SubmissionStatusView;
