class SubmissionStatusView {
  constructor(status) {
    this.status = status;
  }

  render() {
    switch(this.status) {
      case 'queueing':
        return `<div class="submission-status">
          <div class="submission-status-spinner">
            <i aria-hidden="true" class="fas fa-spinner fa-spin"></i>
          </div>
          <p class="submission-status-title">Processing</p>
          <p class="submission-status-status">Queueing</p>
        </div>`
      case 'queued':
        return `<div class="submission-status">
          <div class="submission-status-spinner">
            <i aria-hidden="true" class="fas fa-spinner fa-spin"></i>
          </div>
          <p class="submission-status-title">Processing</p>
          <p class="submission-status-status">Queued</p>
        </div>`
      case 'tested':
        return `<div class="submission-status">
          <div class="submission-status-spinner">
            <i aria-hidden="true" class="fas fa-check-circle"></i>
          </div>
          <p class="submission-status-title">Finished</p>
          <p class="submission-status-status">Tests Complete</p>
        </div>`
      case 'timeout':
        return `<div class="submission-status">
          <div class="submission-status-spinner">
            <i aria-hidden="true" class="fas fa-ellipsis-h"></i>
          </div>
          <p class="submission-status-title">Taking too long?</p>
          <p class="submission-status-status">
            It looks like you've been waiting a while. Re-run your code and
            we'll boost it to the front of the queue.
          </p>
          <button class="js-submit-code pure-button pure-button-primary">
            Re-run your code
          </button>
        </div>`
    }
  }
}

export default SubmissionStatusView
