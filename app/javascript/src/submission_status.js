import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';
import Overlay from './overlay';

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
    }
  }

  render(html) {
    new Overlay().show(html);
    this._onRender();
  }

  _onRender() {
    this._setupActions(new Overlay().getOverlay());

    switch(this.status) {
      case 'cancelled': {
        new Overlay().close();

        break;
      }
      case 'tested': {
        setTimeout(
          () => {
            new Overlay().close();
            this.onTested();
          },
          1000
        )

        break;
      }
    }
  }

  _setupShortcuts() {
    $('body').keydown((e) => {
      if(e.key === 'Escape') { this._cancelBuild(); }
    });
  }

  _setupActions(container) {
    container.find('.js-submit-code').click(this.onSubmit.bind(this));
    container.find('.js-cancel-submission').click(this._cancelBuild.bind(this));
  }

  _cancelBuild() {
    if (this.status !== 'queueing' && this.status !== 'queued') {
      return;
    }

    const cancel = confirm("Are you sure you want to cancel this build?");

    if (cancel) {
      this.setStatus('cancelled');
      this.render();
      this.onCancel();
    }
  }
}

export default SubmissionStatus;
