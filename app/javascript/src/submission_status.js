import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';
import Overlay from './overlay';

class SubmissionStatus {
  constructor(onRender) {
    this.timeout = 30;
    this.timer = new TimeoutTimer(this.timeout, () => {
      this.setStatus('timeout');
    });
    this.onRender = onRender;
  }

  setStatus(status) {
    this.timer.reset();

    switch(status) {
      case 'queueing': {
        this._renderOverlay('queueing');

        this.timer.start();

        break;
      }
      case 'queued': {
        this._renderOverlay('queued');

        this.timer.start();

        break;
      }
      case 'passed':
      case 'failed': {
        this._renderOverlay('tested');

        break;
      }
      case 'timeout': {
        this._renderOverlay('timeout');

        break;
      }
      case 'error': {
        this._renderOverlay('error');

        break;
      }
    }

    this.onRender(new Overlay().getOverlay());
  }

  _renderOverlay(status) {
    const html = new SubmissionStatusView(status).render();

    new Overlay().show(html);
  }
}

export default SubmissionStatus;
