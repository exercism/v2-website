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
    }
  }
}

export default SubmissionStatusView
