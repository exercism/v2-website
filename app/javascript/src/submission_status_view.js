class SubmissionStatusView {
  constructor(status) {
    this.status = status;
  }

  render() {
    switch(this.status) {
      case 'queueing':
        return `<div class="submission-status-queueing">
          <div class="submission-status-spinner">
            <i aria-hidden="true" class="fas fa-spinner fa-spin"></i>
          </div>
          <p class="submission-status-title">Processing</p>
          <p class="submission-status-status">Queueing...</p>
          <button class="js-cancel-submission">Cancel build</button>
        </div>`
      case 'timeout':
        return `<div class="submission-status-timeout">
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
        </div>`
    }
  }
}

export default SubmissionStatusView
