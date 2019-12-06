import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';

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
        this.container.remove();
        this.onCancel();

        break;
      }
      case 'tested': {
        setTimeout(
          () => {
            this.container.remove();
            this.onTested();
          },
          1000
        )

        break;
      }
    }
  }

  render(html) {
    if (this.container) { this.container.remove(); }

    this.container = $(html).appendTo('body');

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
      click(() => { this.container.remove() });
  }

  _cancelBuild() {
    if (this.status !== 'queueing' && this.status !== 'queued') {
      return;
    }

    const cancel = confirm("Are you sure you want to cancel this build?");

    if (cancel) { this.setStatus('cancelled'); }
  }
}

export default SubmissionStatus;
