class SubmissionStatusView {
  constructor(status) {
    this.status = status;
  }

  render() {
    switch(this.status) {
      case 'queueing':
        return `
          <div class="overlay">
            <div class="submission-status-queueing">
              <div class="submission-status-spinner">
                <i aria-hidden="true" class="fas fa-spinner fa-spin"></i>
              </div>
              <p class="submission-status-title">Processing</p>
              <p class="submission-status-status">Queueing...</p>
            </div>
            <div class="submission-cancel">
              <i class="fa-times fal" />
              ESC to
              <a href="#" class="js-cancel-submission">cancel</a>
            </div>
          </div>
        `;
      case 'timeout':
        return `
          <div class="overlay">
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
          </div>
        `
    }
  }
}

export default SubmissionStatusView
