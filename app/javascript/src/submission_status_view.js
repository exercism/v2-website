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
      case 'queued':
        return `<div class="submission-status-queueing">
          <div class="submission-status-spinner">
            <i aria-hidden="true" class="fas fa-spinner fa-spin"></i>
          </div>
          <p class="submission-status-title">Processing</p>
          <p class="submission-status-status">Queued...</p>
          <button class="js-cancel-submission">Cancel build</button>
        </div>`
      case 'tested':
        return `<div class="submission-status-tested">
          <div class="submission-status-spinner">
            <i aria-hidden="true" class="fal fa-check-circle"></i>
          </div>
          <p class="submission-status-title">Finished</p>
          <p class="submission-status-status">Tests complete</p>
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
      case 'error':
        return `<div class="submission-error">
          <div class="submission-error-content">
            <p class="submission-error-title">Sorry</p>
            <p class="submission-error-message">
              Uh oh, it looks like our servers aren't working and we can't run
              your code. Rest assured your work has been saved.
              <br />
              <br />
              Please try to run your code again in a few minutes.
            </p>
            <button class="js-overlay-close pure-button pure-button-primary submission-error-button">
              Continue
            </button>
          </div>
        </div>`
    }
  }
}

export default SubmissionStatusView
