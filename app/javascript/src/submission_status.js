import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';
import SubmissionCancel from './submission_cancel';

class SubmissionStatus {
  constructor() {
    this.timer = new TimeoutTimer(30, () => {
      this.setStatus('timeout');
      this.render(new SubmissionStatusView('timeout').render());
    });

    this._setupShortcuts();
  }

  setStatus(status) {
    this.timer.reset();

    this.status = status;

    switch(this.status) {
      case 'queued':
      case 'queueing': {
        this.timer.start();

        break;
      }
      case 'cancelled': {
        this.remove();
        this.onCancel();

        break;
      }
      case 'tested': {
        setTimeout(
          () => {
            this.remove();
            this.onTested();
          },
          1000
        )

        break;
      }
    }
  }

  remove() {
    this.container.remove();
    this.container = undefined;
  }

  render(html) {
    if (!this.container) { this.container = $('<div />').appendTo('body'); }

    this.container.html(html);

    this._setupActions();
  }

  _setupShortcuts() {
    $('body').keydown((e) => {
      if(e.key === 'Escape') { this._cancelBuild(); }
    });
  }

  _setupActions() {
    this.container.find('.js-submit-code').click(this.onSubmit.bind(this));
    this.
      container.
      find('.js-cancel-submission').
      click(this._cancelBuild.bind(this));
    this.
      container.
      find('.js-overlay-close').
      click(() => { this.remove(); });
  }

  _cancelBuild() {
    if (this.status !== 'queueing' && this.status !== 'queued') { return; }
    if (this.cancelling) { return; }

    this.cancelling = true;

    const submissionCancel = new SubmissionCancel();
    submissionCancel.onConfirm = () => {
      this.setStatus('cancelled');
      this.cancelling = false;
    };
    submissionCancel.onRefuse = () => { this.cancelling = false; };

    submissionCancel.render();
  }
}

export default SubmissionStatus;
