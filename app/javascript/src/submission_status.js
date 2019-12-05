import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';
import Overlay from './overlay';

class SubmissionStatus {
  constructor() {
    this.timer = new TimeoutTimer(1, () => { this.setStatus('timeout'); });

    this._setupShortcuts();
  }

  _setupShortcuts() {
    $('body').keydown((e) => {
      if(e.key === 'Escape') { this._cancelBuild(); }
    });
  }

  setStatus(status) {
    this.status = status;

    this.timer.reset();

    switch(status) {
      case 'queueing':
      case 'queued': {
        this._renderOverlay(status);
        this.timer.start();

        break;
      }
      case 'timeout':
      case 'error': {
        this._renderOverlay(status);

        break;
      }
      case 'passed':
      case 'failed': {
        this._renderOverlay('tested');
        setTimeout(
          () => { new Overlay().close(); this.onTested(); },
          1000
        )

        break;
      }
      case 'cancelled': {
        new Overlay().close();

        break;
      }
    }
  }

  _renderOverlay(status) {
    const html = new SubmissionStatusView(status).render();

    new Overlay().show(html);
    this._setupActions(new Overlay().getOverlay());
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
      this.onCancel();
    }
  }
}

export default SubmissionStatus;
